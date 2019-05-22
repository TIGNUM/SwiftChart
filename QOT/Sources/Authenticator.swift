//
//  Authenticator.swift
//  QOT
//
//  Created by Sam Wyndham on 30/01/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation
import qot_dal

typealias AuthenticationCompletion = (Result<String, NetworkError>) -> Void

final class Authenticator {
    private let sessionSerivce = SessionService.main
    private let notificationCenter: NotificationCenter

    init(notificationCenter: NotificationCenter = NotificationCenter.default) {
        self.notificationCenter = notificationCenter
    }

    func authenticate(username: String, password: String, completion: @escaping AuthenticationCompletion) {
        _authenticate(username: username, password: password, completion: completion)
    }

    func fetchAuthToken(now: Date = Date(), completion: @escaping AuthenticationCompletion) {
        _fetchAuthToken(now: now, completion: completion)
    }

    func hasLoginCredentials() -> Bool {
        return sessionSerivce.getCurrentSession() != nil
    }

    func refreshSession(completion: @escaping AuthenticationCompletion) {
        sessionSerivce.refreshSession { (newSession, error) in
            if let session = newSession {
                completion(.success(session.sessionToken ?? ""))
            } else {
                completion(.failure(error!.networkError))
            }
        }
    }

}

// MARK: NOT THREAD SAFE! Methods in this extension MUST all be called on `queue`.
private extension Authenticator {

    func _authenticate(username: String, password: String, completion: @escaping AuthenticationCompletion) {
        sessionSerivce.createSession(username: username, password: password) { (newSession, error) in
            if let session = newSession {
                completion(.success(session.sessionToken ?? ""))
            } else {
                completion(.failure(error!.networkError))
            }
        }
    }

    func _fetchAuthToken(now: Date, completion: @escaping AuthenticationCompletion) {
        if let session = sessionSerivce.getCurrentSession() {
            completion(.success(session.sessionToken ?? ""))
        } else {
            completion(.failure(NetworkError(type: .unauthenticated)))
        }
    }
}
