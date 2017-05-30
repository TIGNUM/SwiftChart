//
//  NetworkManager.swift
//  QOT
//
//  Created by Sam Wyndham on 30.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import Alamofire

final class NetworkManger {

    private let sessionManager: SessionManager
    private let credentialsManager: CredentialsManager
    private let baseURL: URL

    init(sessionManager: SessionManager, credentialsManager: CredentialsManager, baseURL: URL) {
        self.sessionManager = sessionManager
        self.credentialsManager = credentialsManager
        self.baseURL = baseURL
    }

    /**
     Performs a network request using credentials from the `CredentialsManager`.
     
     If the user has has no username and password in the keychain completes with `NetworkError.unauthenticated`.
     If the user has no token, first authenticates before performing the request.
     If the users token is not accepted by the server, trys to reauthenticate before reperforming the request.
    */
    @discardableResult func request<T>(_ urlRequest: URLRequest, parser: @escaping (Data) throws -> T, completion: @escaping (Result<T, NetworkError>) -> Void) -> SerialRequest {
        guard let credential = credentialsManager.credential else {
            completion(.failure(.unauthenticated))
            return SerialRequest()
        }

        let serialRequest = SerialRequest()
        if let token = credential.token {
            setTokenAndRequest(urlRequest, token: token, parser: parser, serialRequest: serialRequest) { [weak self] (result) in
                switch result {
                case .success:
                    completion(result)
                case .failure(let error):
                    switch error {
                    case .unauthenticated:
                        self?.authenticateAndRequest(urlRequest, username: credential.username, password: credential.password, parser: parser, serialRequest: serialRequest, completion: completion)
                    default:
                        completion(result)
                    }
                }
            }
        } else {
            authenticateAndRequest(urlRequest, username: credential.username, password: credential.password, parser: parser, serialRequest: serialRequest, completion: completion)
        }
        return serialRequest
    }

    // MARK: Private

    private func authenticateAndRequest<T>(_ urlRequest: URLRequest, username: String, password: String, parser: @escaping (Data) throws -> T, serialRequest: SerialRequest, completion: @escaping (Result<T, NetworkError>) -> Void) {
        let authRequest = URLRequest.authentication(baseURL: baseURL, username: username, password: password)
        serialRequest.request = sessionManager.request(authRequest, parser: AuthenticationTokenParser.parse) { [weak self] (authResult) in
            guard let strongSelf = self else {
                return
            }

            switch authResult {
            case .success(let token):
                strongSelf.credentialsManager.credential = Credential(username: username, password: password, token: token)
                strongSelf.setTokenAndRequest(urlRequest, token: token, parser: parser, serialRequest: serialRequest, completion: completion)
            case .failure(let error):
                switch error {
                case .unauthenticated:
                    strongSelf.credentialsManager.credential = nil
                default:
                    break
                }
                completion(.failure(error))
            }
        }
    }

    private func setTokenAndRequest<T>(_ urlRequest: URLRequest, token: String, parser: @escaping (Data) throws -> T, serialRequest: SerialRequest, completion: @escaping (Result<T, NetworkError>) -> Void) {
        var req =  urlRequest
        req.setToken(token)

        serialRequest.request = sessionManager.request(req, parser: parser, completion: completion)
    }

}

// FIXME: Make private
extension SessionManager {

    @discardableResult func request<T>(_ urlRequest: URLRequestConvertible, parser: @escaping (Data) throws -> T, completion: @escaping (Result<T, NetworkError>) -> Void) -> DataRequest {
        return self.request(urlRequest)
            .validate(statusCode: 200..<300)
            .responseData { response in
                let result: Result<T, NetworkError>
                switch response.result {
                case .success(let data):
                    do {
                        result = .success(try parser(data))
                    } catch let error {
                        result = .failure(.failedToParseData(data, error: error))
                    }
                case .failure(let error):
                    let networkError = NetworkError(error: error as NSError, statusCode: response.response?.statusCode)
                    result = .failure(networkError)
                }
                completion(result)
        }
    }
}
