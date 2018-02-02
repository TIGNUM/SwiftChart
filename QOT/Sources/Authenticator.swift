//
//  Authenticator.swift
//  QOT
//
//  Created by Sam Wyndham on 30/01/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation
import Alamofire
import JWT

typealias AuthenticationCompletion = (Result<String, NetworkError>) -> Void

final class Authenticator {

    struct Config {
        let expiryLeaway = TimeInterval(minutes: 10)
    }

    private let queue = DispatchQueue(label: "Authenticator", qos: .background)
    private let config = Config()
    private let sessionManager: SessionManager
    private let requestBuilder: URLRequestBuilder
    private let store = CredentialsManager.shared
    private let notificationCenter: NotificationCenter
    private var completions: [AuthenticationCompletion] = []
    private var currentRequest: (token: Token, request: DataRequest)?

    init(sessionManager: SessionManager,
         requestBuilder: URLRequestBuilder,
         notificationCenter: NotificationCenter = NotificationCenter.default) {
        self.sessionManager = sessionManager
        self.requestBuilder = requestBuilder
        self.notificationCenter = notificationCenter
    }

    func authenticate(username: String, password: String, completion: @escaping AuthenticationCompletion) {
        queue.async { self._authenticate(username: username, password: password, completion: completion) }
    }

    func fetchAuthToken(now: Date = Date(), completion: @escaping AuthenticationCompletion) {
        queue.async { self._fetchAuthToken(now: now, completion: completion) }
    }

    func hasLoginCredentials() -> Bool {
        return store.hasLoginCredentials
    }
}

// MARK: NOT THREAD SAFE! Methods in this extension MUST all be called on `queue`.
private extension Authenticator {

    func _authenticate(username: String, password: String, completion: @escaping AuthenticationCompletion) {
        dispatchPrecondition(condition: .onQueue(queue))

        cancelCurrentRequest()
        completions.append(completion)
        authenticateAndCallCompletions(username: username, password: password, saveCredentials: true)
    }

    func _fetchAuthToken(now: Date, completion: @escaping AuthenticationCompletion) {
        dispatchPrecondition(condition: .onQueue(queue))

        let minExpirationDate = now.addingTimeInterval(-config.expiryLeaway)
        if currentRequest != nil {
            completions.append(completion)
        } else if let existingAuthToken = validAuthToken(minExpiry: minExpirationDate) {
            completion(.success(existingAuthToken))
        } else if let (username, password) = loginCredentials() {
            completions.append(completion)
            authenticateAndCallCompletions(username: username, password: password, saveCredentials: false)
        } else {
            completion(.failure(NetworkError(type: .unauthenticated)))
        }
    }

    private func cancelCurrentRequest() {
        dispatchPrecondition(condition: .onQueue(queue))

        if let request = currentRequest {
            request.token.invalidate()
            request.request.cancel()
            currentRequest = nil
        }
        performCompletions(with: .failure(NetworkError(type: .cancelled)))
    }

    private func authenticateAndCallCompletions(username: String, password: String, saveCredentials: Bool) {
        dispatchPrecondition(condition: .onQueue(queue))

        let token = Token()
        let req = requestBuilder.make(buildable: AuthenticationRequest(username: username, password: password))
        let parser = AuthenticationTokenParser.make()
        let request = sessionManager.request(req, parser: parser, completionQueue: queue) { [weak self] (result) in
            guard let `self` = self, token.isValid() == true else { return }

            switch result {
            case .success(let authToken):
                if saveCredentials == true {
                    self.store.save(username: username, password: password, authToken: authToken)
                } else {
                    self.save(authToken: authToken)
                }
            case .failure(let error):
                if error.isUnauthenticated {
                    self.clearLoginCredentialsAndAuthToken()
                }
            }
            self.performCompletions(with: result)
            self.currentRequest = nil
        }
        self.currentRequest = (token: token, request: request)
    }

    private func save(username: String, password: String, authToken: String) {
        dispatchPrecondition(condition: .onQueue(queue))

        store.save(username: username, password: password, authToken: authToken)
    }

    private func save(authToken: String) {
        dispatchPrecondition(condition: .onQueue(queue))

        store.save(authToken: authToken)
    }

    private func clearLoginCredentialsAndAuthToken() {
        dispatchPrecondition(condition: .onQueue(queue))

        store.clear()
    }

    private func performCompletions(with result: Result<String, NetworkError>) {
        dispatchPrecondition(condition: .onQueue(queue))

        for completion in completions {
            DispatchQueue.main.async {
                completion(result)
            }
        }
        completions = []
    }

    private func validAuthToken(minExpiry: Date) -> String? {
        dispatchPrecondition(condition: .onQueue(queue))

        guard let existingToken = store.authToken() else { return nil }
        do {
            let claims: ClaimSet = try JWT.decode(existingToken, algorithm: .none, verify: false)
            if let expiration = claims.expiration {
                return expiration >= minExpiry ? existingToken : nil
            } else {
                assertionFailure("ASSUMPTION - Auth tokens MUST have an expiration")
                log("Authentication token has no expiration: \(existingToken)", level: .error)
                return nil
            }
        } catch {
            log("Failed to decode authentication token: \(existingToken), error: \(error)", level: .error)
            return nil
        }
    }

    private func loginCredentials() -> (username: String, password: String)? {
        dispatchPrecondition(condition: .onQueue(queue))

        return store.loginCredentials()
    }
}
