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
import CoreLocation

protocol NetworkManagerDelegate: class {

    func networkManagerFailedToAuthenticate(_ networkManager: NetworkManager)
}

final class NetworkManager {

    private let sessionManager: SessionManager
    private let authenticator: Authenticator
    private let requestBuilder: URLRequestBuilder
    weak var delegate: NetworkManagerDelegate?

    init(delegate: NetworkManagerDelegate? = nil,
         sessionManager: SessionManager = SessionManager.default,
         authenticator: Authenticator,
         requestBuilder: URLRequestBuilder = URLRequestBuilder(deviceID: deviceID)) {
        self.delegate = delegate
        self.sessionManager = sessionManager
        self.authenticator = authenticator
        self.requestBuilder = requestBuilder
    }

    func cancelAllRequests() {
        sessionManager.session.getAllTasks { $0.forEach { $0.cancel() } }
    }

    func performAuthenticationRequest(username: String,
                                      password: String,
                                      completion: @escaping (NetworkError?) -> Void) {
        authenticator.authenticate(username: username, password: password) { (result) in
            completion(result.error)
        }
    }

    @discardableResult func performDevicePermissionsRequest(with data: Data,
                                                            completion: @escaping (NetworkError?) -> Void) -> SerialRequest {
        let current = SerialRequest()
        performAuthenticatingRequest(DevicePermissionsRequest(data: data),
                                     parser: GenericParser.parse,
                                     notifyDelegateOfFailure: false,
                                     current: current) { (result) in
                                        completion(result.error)
        }
        return current
    }

    @discardableResult func performResetPasswordRequest(username: String,
                                                        completion: @escaping (NetworkError?) -> Void) -> SerialRequest {

        let req = requestBuilder.make(buildable: ResetPasswordRequest(username: username))
        let current = SerialRequest()
        current.request = sessionManager.request(req, parser: GenericParser.parse) { (result) in
            completion(result.error)
        }
        return current
    }

    @discardableResult func performAPNSDeviceTokenRequest(token: String,
                                                          urbanAirshipAppKey: String,
                                                          completion: @escaping (NetworkError?) -> Void) -> SerialRequest {
        let current = SerialRequest()
        performAuthenticatingRequest(APNSDeviceTokenRequest(token: token, urbanAirshipAppKey: urbanAirshipAppKey),
                                     parser: GenericParser.parse,
                                     notifyDelegateOfFailure: false,
                                     current: current) { (result) in
                                        completion(result.error)
        }
        return current
    }

    @discardableResult func performUserAnswerFeedbackRequest(userAnswers: [UserAnswer],
                                                       completion: @escaping (Result<UserAnswerFeedback, NetworkError>) -> Void) -> SerialRequest {
        let current = SerialRequest()
        performAuthenticatingRequest(UserAnswerFeedbackRequest(userAnswers),
                                     parser: UserAnswerFeedback.parse,
                                     notifyDelegateOfFailure: false,
                                     current: current,
                                     completion: completion)
        return current
    }

    @discardableResult func performUserLocationUpdateRequest(location: CLLocation,
                                                             completion: @escaping (NetworkError?) -> Void) -> SerialRequest {
        let current = SerialRequest()
        performAuthenticatingRequest(UserLocationUpdateRequest(location),
                                     parser: GenericParser.parse,
                                     notifyDelegateOfFailure: false,
                                     current: current) { (result) in
            completion(result.error)
        }
        return current
    }

    @discardableResult func performDeviceRequest() -> SerialRequest {
        let serialRequest = SerialRequest()
        guard authenticator.hasLoginCredentials() else { return serialRequest }

        struct Device: Encodable {
            let deviceIdentifier = deviceID
            let systemName = UIDevice.current.systemName
            let systemVersion = UIDevice.current.fullSystemVersion
            let name = UIDevice.current.name
            let model = UIDevice.current.modelName
        }
        guard let deviceData = try? JSONEncoder().encode([Device()]) else { return serialRequest }

        performAuthenticatingRequest(StartSyncRequest(from: 0),
                                     parser: StartSyncResult.parse,
                                     notifyDelegateOfFailure: false,
                                     current: serialRequest) { startSyncResult in
            switch startSyncResult {
            case .success(let result):
                self.performAuthenticatingRequest(DeviceRequest(data: deviceData, syncToken: result.syncToken),
                                             parser: GenericParser.parse,
                                             notifyDelegateOfFailure: false,
                                             current: serialRequest) { deviceResult in
                    switch deviceResult {
                    case .success:
                        log("Successfully sent device info")
                    case .failure(let error):
                        log("Failed to send device info: \(error)")
                    }
                }
            case .failure(let error):
                log("Failed to send device info: \(error)")
            }
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
        authenticator.fetchAuthToken { (authResult) in
            switch authResult {
            case .success(let authToken):
                let req = self.requestBuilder.make(buildable: request, authToken: authToken)
                current.request = self.sessionManager.request(req, parser: parser) { (mainResult) in
                    switch mainResult {
                    case .success(let value):
                        completion(.success(value))
                    case .failure(let error):
                        completion(.failure(error))
                        if error.isUnauthenticated && notifyDelegateOfFailure {
                            self.notifyDelegateOfAuthenticationFailure(error)
                        }
                    }
                }
            case .failure(let error):
                completion(.failure(error))
                if error.isUnauthenticated && notifyDelegateOfFailure {
                    self.notifyDelegateOfAuthenticationFailure(error)
                }
            }
        }
    }

    private func notifyDelegateOfAuthenticationFailure(_ error: NetworkError) {
        #if DEBUG
            // Log to file on debug builds BEFORE notifying delegate.
            let token = String(describing: CredentialsManager.shared.authToken())
            log("AUTH ERROR: \(error), TOKEN: \(token)", level: .debug)
        #endif
        DispatchQueue.main.async {
            self.delegate?.networkManagerFailedToAuthenticate(self)
        }
    }
}

// FIXME: Move
extension SessionManager {

    @discardableResult func request<T>(_ urlRequest: URLRequestConvertible,
                                       parser: @escaping (Data) throws -> T,
                                       completionQueue: DispatchQueue? = nil,
                                       completion: @escaping (Result<T, NetworkError>) -> Void) -> DataRequest {
        return perform(urlRequest, parser: parser, completionQueue: completionQueue) { (response, result) in
            completion(result)
        }
    }

    @discardableResult func perform<T>(_ urlRequest: URLRequestConvertible,
                                       parser: @escaping (Data) throws -> T,
                                       completionQueue: DispatchQueue? = nil,
                                       completion: @escaping (DataResponse<Data>, Result<T, NetworkError>) -> Void) -> DataRequest {
        return self.request(urlRequest)
            .validate(statusCode: 200..<300)
            .responseData(queue: completionQueue) { response in
                log("REQUEST BODY DATA: \(response.request?.httpBody?.utf8String ?? "No request body data")", level: .verbose)
                log("RESPONSE BODY DATA: \(response.data?.utf8String ?? "No response data")", level: .verbose)

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
                completion(response, result)
        }
    }
}
