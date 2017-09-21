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
import PromiseKit

protocol NetworkManagerDelegate: class {
    func networkManagerFailedToAuthenticate(_ networkManager: NetworkManager)
}

class NetworkManager {

    fileprivate let sessionManager: SessionManager
    fileprivate let credentialsManager: CredentialsManager
    fileprivate let requestBuilder: URLRequestBuilder
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
         credentialsManager: CredentialsManager = CredentialsManager.shared,
         requestBuilder: URLRequestBuilder = URLRequestBuilder(baseURL: baseURL, deviceID: deviceID)
        ) {
        self.delegate = delegate
        self.sessionManager = sessionManager
        self.credentialsManager = credentialsManager
        self.requestBuilder = requestBuilder
    }

    @discardableResult func performAuthenticationRequest(username: String,
                                                         password: String,
                                                         completion: @escaping (NetworkError?) -> Void) -> SerialRequest {

        let parser = AuthenticationTokenParser.make(username: username, password: password)
        let request = AuthenticationRequest(username: username, password: password)
        return performRequest(request, parser: parser) { [credentialsManager] (result) in
            switch result {
            case .success(let credential):
                credentialsManager.credential = credential
                completion(nil)
            case .failure(let error):
                completion(error.networkError)
            }
        }
    }

    @discardableResult func performResetPasswordRequest(username: String,
                                                        completion: @escaping (NetworkError?) -> Void) -> SerialRequest {
        let request = ResetPasswordRequest(username: username)
        return performRequest(request, completion: completion)
    }

    @discardableResult func performAPNSDeviceTokenRequest(token: String,
                                                          completion: @escaping (NetworkError?) -> Void) -> SerialRequest {
        let request = APNSDeviceTokenRequest(token: token)
        return performRequest(request, completion: completion)
    }

    @discardableResult func performVersionInfoRequest(completion: @escaping (Result<VersionInfo, NetworkError>) -> Void) -> SerialRequest {
        return performRequest(VersionInfoRequest(), parser: VersionInfo.parse, completion: completion)
    }

    /**
     Performs a network request using credentials from the `CredentialsManager`.
     
     If the user has has no username and password in the keychain completes with `NetworkError.unauthenticated`.
     If the user has no token, first authenticates before performing the request.
     If the users token is not accepted by the server, trys to reauthenticate before reperforming the request.
    */
    @discardableResult func request<T>(_ urlRequest: URLRequestBuildable, parser: @escaping (Data) throws -> T, completion: @escaping (Result<T, NetworkError>) -> Void) -> SerialRequest {
        let serialRequest = SerialRequest()
        performAuthenticatingRequest(urlRequest, parser: parser, current: serialRequest, completion: completion)
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

    private func performAuthenticatingRequest<T>(_ request: URLRequestBuildable,
                                              parser: @escaping (Data) throws -> T,
                                              notifyDelegateOfFailure: Bool = true,
                                              current: SerialRequest,
                                              completion: @escaping (Result<T, NetworkError>) -> Void) {

        firstly { 
            return self.performRequest(request, parser: parser, current: current)
        }.then { (value) -> Void in
            completion(.success(value))
            // Finish chain here by cancelling
            throw NSError.cancelledError()
        }.recover { (error) -> Promise<Void> in
            guard NetworkError.isUnauthenticatedNetworkError(error) == true else {
                throw error
            }
            return Promise()
        }.then { (_) -> Promise<Credential> in
            return self.authenticate(current: current)
        }.then { (credential) -> Promise<Void> in
            self.credentialsManager.credential = credential
            return Promise()
        }.then { (_) -> Promise<T> in
            return self.performRequest(request, parser: parser, current: current)
        }.then { (value) -> Void in
            completion(.success(value))
        }.catch { (error) in
            if NetworkError.isUnauthenticatedNetworkError(error) == true {
                self.credentialsManager.credential = nil
                if notifyDelegateOfFailure == true {
                    self.delegate?.networkManagerFailedToAuthenticate(self)
                }
            }
            completion(.failure(error.networkError))
        }
    }

    private func performRequest(_ request: URLRequestBuildable, completion: @escaping (NetworkError?) -> Void) -> SerialRequest {
        return performRequest(request, parser: { return $0 }) { (result) in
            completion(result.error)
        }
    }

    private func performRequest<T>(_ request: URLRequestBuildable,
                                parser: @escaping (Data) throws -> T,
                                completion: @escaping (Result<T, NetworkError>) -> Void) -> SerialRequest {

        let current = SerialRequest()
        firstly {
            return performRequest(request, parser: parser, current: current)
        }.then { (value) in
            completion(.success(value))
        }.catch { (error) in
            completion(.failure(error.networkError))
        }
        return current
    }

    // MARK: Promises

    private func performRequest<T>(_ request: URLRequestBuildable,
                                parser: @escaping (Data) throws -> T,
                                current: SerialRequest?) -> Promise<T> {

        return Promise { fulfill, reject in
            let req = try self.requestBuilder.make(with: request, authToken: credentialsManager.credential?.token)
            current?.request = sessionManager.request(req, parser: parser) { (result) in
                switch result {
                case .success(let value):
                    fulfill(value)
                case .failure(let error):
                    reject(error)
                }
            }
        }
    }

    private func authenticate(current: SerialRequest?) -> Promise<Credential> {
        if let credential = credentialsManager.credential {
            let username = credential.username
            let password = credential.password
            let request = AuthenticationRequest(username: username, password: password)
            let parser = AuthenticationTokenParser.make(username: username, password: password)
            return performRequest(request, parser: parser, current: current)
        } else {
            return Promise(error: NetworkError(type: .unauthenticated))
        }
    }
}

// FIXME: Make private
extension SessionManager {

    @discardableResult func request<T>(_ urlRequest: URLRequestConvertible, parser: @escaping (Data) throws -> T, completion: @escaping (Result<T, NetworkError>) -> Void) -> DataRequest {
        return self.request(urlRequest)
            .validate(statusCode: 200..<300)
            .responseData { response in
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
