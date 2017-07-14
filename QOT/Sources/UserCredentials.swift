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
    let username: String?
    let password: String?
    let token: String?
}

private let keychain = Keychain(service: KeychainConstant.service.rawValue)

class CredentialsManager {
    var credential: Credential? {
        get {
            return Credential(username: value(key: .username), password: value(key: .password), token: value(key: .authToken))
        }
        set {
            set(value: newValue?.username, key: .username)
            set(value: newValue?.password, key: .password)
            set(value: newValue?.token, key: .authToken)
        }
    }

    func deleteToken() {
        set(value: nil, key: .authToken)
    }

    private func value(key: KeychainConstant) -> String? {
        return keychain[key.rawValue]
    }

    private func set(value: String?, key: KeychainConstant) {
        keychain[key.rawValue] = value
    }
}
