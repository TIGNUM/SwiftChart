//
//  UserCredentials.swift
//  QOT
//
//  Created by karmic on 19.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import KeychainAccess

enum Credentials {
    case authToken
    case username
    case password

    // MARK: - Set

    static func storeAuthToken(token: String) {
        Credentials.authToken.store(value: token)
    }

    static func storeUsernamePassword(username: String, password: String) {
        Credentials.username.store(value: username)
        Credentials.password.store(value: password)
    }

    // MARK: - Get

    static var token: String? {
        return Credentials.authToken.item
    }

    static var usernamePassword: (username: String, password: String)? {
        guard
            let username = Credentials.username.item,
            let password = Credentials.password.item else {
                return nil
        }

        return (username: username, password: password)
    }

    // MARK: - Remove

    static func removeAuthToken() {
        Credentials.authToken.remove()
    }

    static func removeUsernamePassword() {
        Credentials.username.remove()
        Credentials.password.remove()
    }
}

// MARK: - Private

private extension Credentials {

    var keychain: Keychain {
        return Keychain(service: service)
    }

    var key: String {
        switch self {
        case .authToken: return "qot.key.chain.key.authtoken"
        case .password: return "qot.key.chain.key.password"
        case .username: return "qot.key.chain.key.username"
        }
    }

    var service: String {
        switch self {
        case .authToken: return "qot.key.chain.service.authtoken"
        case .password: return "qot.key.chain.service.password"
        case .username: return "qot.key.chain.service.username"
        }
    }

    var item: String? {
        return keychain[key]
    }

    func store(value: String) {
        keychain[key] = value
    }

    func remove() {
        keychain[key] = nil
    }
}
