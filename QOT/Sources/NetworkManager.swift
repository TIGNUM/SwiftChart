//
//  NetworkManager.swift
//  QOT
//
//  Created by Sam Wyndham on 30.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import Alamofire
import Freddy

protocol NetworkManagerDelegate: class {
    func networkManagerFailedToAuthenticate(_ networkManager: NetworkManager)
}

class NetworkManager {

    private let sessionManager: SessionManager
    private let credentialsManager: CredentialsManager
    private let requestBuilder: URLRequestBuilder
    var credential: Credential? {
        get {
            return credentialsManager.credential
        }
        set {
            credentialsManager.credential = newValue
        }
    }
    weak var delegate: NetworkManagerDelegate?
    
    init(delegate: NetworkManagerDelegate? = nil,
         sessionManager: SessionManager = SessionManager.default,
         credentialsManager: CredentialsManager = CredentialsManager(),
         requestBuilder: URLRequestBuilder = URLRequestBuilder(baseURL: baseURL, deviceID: deviceID)
        ) {
        self.delegate = delegate
        self.sessionManager = sessionManager
        self.credentialsManager = credentialsManager
        self.requestBuilder = requestBuilder
    }
    
    @discardableResult func request(_ authRequest: AuthenticationRequest, parser: @escaping (Data) throws -> String, completion: @escaping (Result<String, NetworkError>) -> Void) -> SerialRequest {
        let serialRequest = SerialRequest()
        let request = requestBuilder.make(with: authRequest, authToken: nil)
        serialRequest.request = sessionManager.request(request, parser: parser) { [weak self] (result) in
            guard let `self` = self else {
                return
            }
            
            switch result {
            case .success(let token):
                self.credentialsManager.credential = Credential(username: authRequest.username, password: authRequest.password, token: token)
                completion(result)
            case .failure(let error):
                completion(.failure(error))
            }
        }
        return serialRequest
    }

    @discardableResult func request<T>(_ authRequest: ResetPasswordRequest, parser: @escaping (Data) throws -> T, completion: @escaping (Result<T, NetworkError>) -> Void) -> SerialRequest {
        let serialRequest = SerialRequest()
        let request = requestBuilder.make(with: authRequest, authToken: nil)
        serialRequest.request = sessionManager.request(request, parser: parser) { (result) in
            completion(result)
        }
        return serialRequest
    }

    @discardableResult func request<T>(_ authRequest: EmailCheckRequest, parser: @escaping (Data) throws -> T, completion: @escaping (Result<T, NetworkError>) -> Void) -> SerialRequest {

        var httpHeaders = authRequest.headers
        httpHeaders[.contentType] = "application/json"
        httpHeaders[.deviceID] = deviceID

        let method = authRequest.httpMethod
        let headers = httpHeaders.mapKeys { $0.rawValue }
        var url = authRequest.endpoint.url(baseURL: baseURL)
        let params = authRequest.paramaters.mapKeys { $0.rawValue }

        if let string = authRequest.email {
            url.appendPathComponent(string)
        }

        let request = URLRequest(url: url, method: method, headers: headers, parameters: params, body: authRequest.body)

        let serialRequest = SerialRequest()
        serialRequest.request = sessionManager.request(request, parser: parser) { (result) in
            completion(result)
        }
        return serialRequest
    }

    /**
     Performs a network request using credentials from the `CredentialsManager`.
     
     If the user has has no username and password in the keychain completes with `NetworkError.unauthenticated`.
     If the user has no token, first authenticates before performing the request.
     If the users token is not accepted by the server, trys to reauthenticate before reperforming the request.
    */
    @discardableResult func request<T>(_ urlRequest: URLRequestBuildable, parser: @escaping (Data) throws -> T, completion: @escaping (Result<T, NetworkError>) -> Void) -> SerialRequest {
        let serialRequest = SerialRequest()
        guard let credential = credential else {
            completion(.failure(NetworkError(type: .unauthenticated)))
            return serialRequest
        }
        if let token = credential.token {
            setTokenAndRequest(urlRequest, token: token, parser: parser, serialRequest: serialRequest) { [weak self] (result) in
                switch result {
                case .success:
                    completion(result)
                case .failure(let error):
                    switch error.type {
                    case .unauthenticated:
                        self?.authenticateAndRequest(urlRequest, username: credential.username, password: credential.password, parser: parser, serialRequest: serialRequest, completion: completion)
                    default:
                        completion(result)
                    }
                }
            }
        } else {
            authenticateAndRequest(urlRequest, username: credential.username, password: credential.password, parser: parser, serialRequest: serialRequest, completion: { [weak self] (authResult) in
                completion(authResult)
                guard let `self` = self else {
                    return
                }
                self.delegate?.networkManagerFailedToAuthenticate(self)
            })
        }
        return serialRequest
    }

    @discardableResult func request<T: DownSyncIntermediary>(token: String, endpoint: Endpoint, page: Int, accumulator: [DownSyncChange<T>] = [], serialRequest: SerialRequest? = nil, completion: @escaping (Result<([DownSyncChange<T>], String), NetworkError>) -> Void) -> SerialRequest {
        let serialRequest = serialRequest ?? SerialRequest()

        let urlRequest = DownSyncRequest(endpoint: endpoint, syncToken: token, page: page)
        serialRequest.request = self.request(urlRequest, parser: DownSyncResultParser<T>.parse) { [weak self] (result) in
            switch result {
            case .success(let value):
                let changes = accumulator + value.items
                if page >= value.maxPages {
                    completion(.success((changes, value.nextSyncToken)))
                } else {
                    let page = page + 1
                    self?.request(token: value.nextSyncToken, endpoint: endpoint, page: page, accumulator: changes, serialRequest: serialRequest, completion: completion)
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }.request
        return serialRequest
    }
    
    // MARK: Private

    private func authenticateAndRequest<T>(_ urlRequest: URLRequestBuildable, username: String, password: String, parser: @escaping (Data) throws -> T, serialRequest: SerialRequest, completion: @escaping (Result<T, NetworkError>) -> Void) {
        let authRequest = AuthenticationRequest(username: username, password: password, deviceID: deviceID)
        let req = requestBuilder.make(with: authRequest, authToken: nil)
        serialRequest.request = sessionManager.request(req, parser: AuthenticationTokenParser.parse) { [weak self] (authResult) in
            guard let strongSelf = self else {
                return
            }

            switch authResult {
            case .success(let token):
                strongSelf.credentialsManager.credential = Credential(username: username, password: password, token: token)
                strongSelf.setTokenAndRequest(urlRequest, token: token, parser: parser, serialRequest: serialRequest, completion: completion)
            case .failure(let error):
                switch error.type {
                case .unauthenticated:
                    strongSelf.credentialsManager.credential = nil
                default:
                    break
                }
                completion(.failure(error))
            }
        }
    }

    private func setTokenAndRequest<T>(_ urlRequest: URLRequestBuildable, token: String, parser: @escaping (Data) throws -> T, serialRequest: SerialRequest, completion: @escaping (Result<T, NetworkError>) -> Void) {
        let req = requestBuilder.make(with: urlRequest, authToken: token)
        serialRequest.request = sessionManager.request(req, parser: parser, completion: completion)
    }

}

// FIXME: Make private
extension SessionManager {

    @discardableResult func request<T>(_ urlRequest: URLRequestConvertible, parser: @escaping (Data) throws -> T, completion: @escaping (Result<T, NetworkError>) -> Void) -> DataRequest {
        return self.request(urlRequest)
            .validate(statusCode: 200..<300)
            .responseData { response in
                // @note useful for big responses
//                let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
//                var path = "\(paths[0])/result.txt"
//                print(path)
//                try? response.request?.httpBody?.write(to: URL(fileURLWithPath: path))
                
                log("REQUEST BODY DATA: \(response.request?.httpBody?.utf8String ?? "No request body data")", enabled: LogToggle.NetworkManager.requestBody)
                log("RESPONSE BODY DATA: \(response.data?.utf8String ?? "No response data")", enabled: LogToggle.NetworkManager.responseBody)
                
                let result: Result<T, NetworkError>
                switch response.result {
                case .success(let data):
                    do {
                        result = .success(try parser(data))
                    } catch let error {
                        let networkError = NetworkError(type: .failedToParseData(data, error: error))
                        result = .failure(networkError)
                    }
                case .failure(let error):
                    let networkError = NetworkError(error: error as NSError, request: response.request, response: response.response, data: response.data)
                    result = .failure(networkError)
                }
                completion(result)
        }
    }
}
