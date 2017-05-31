//
//  UserCredentials.swift
//  QOT
//
//  Created by karmic on 19.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import KeychainAccess

struct Credential {
    let username: String
    let password: String
    let token: String?
}

private let keychain = Keychain(service: "com.tignum.qot")

class CredentialsManager {

    enum Key: String {
        case username = "com.tignum.qot.username"
        case password = "com.tignum.qot.password"
        case token = "com.tignum.qot.token"
    }

    var credential: Credential? {
        get {
            guard let username = value(key: .username), let password = value(key: .password) else {
                return nil
            }
            return Credential(username: username, password: password, token: value(key: .token))
        }
        set {
            set(value: newValue?.username, key: .username)
            set(value: newValue?.password, key: .password)
            set(value: newValue?.token, key: .token)
        }
    }

    func deleteToken() {
        set(value: nil, key: .token)
    }

    private func value(key: Key) -> String? {
        return keychain[key.rawValue]
    }

    private func set(value: String?, key: Key) {
        keychain[key.rawValue] = value
    }
}
