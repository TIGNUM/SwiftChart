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

private let keychain = Keychain(service: KeychainConstant.service.rawValue)

final class CredentialsManager {
    var credential: Credential? {
        get {
            guard let username = value(key: .username), let password = value(key: .password) else {
                return nil
            }
            return Credential(username: username, password: password, token: value(key: .authToken))
        }
        set {
            set(value: newValue?.username, key: .username)
            set(value: newValue?.password, key: .password)
            set(value: newValue?.token, key: .authToken)
        }
    }
    
    var isCredentialValid: Bool {
        guard let credential = credential else {
            return false
        }
        return (credential.token != nil)
    }

    func deleteToken() {
        set(value: nil, key: .authToken)
    }
    
    func clear() {
        set(value: nil, key: .username)
        set(value: nil, key: .password)
        set(value: nil, key: .authToken)
    }
    
    // MARK: - private
    
    private func value(key: KeychainConstant) -> String? {
        return keychain[key.rawValue]
    }

    private func set(value: String?, key: KeychainConstant) {
        keychain[key.rawValue] = value
    }
}
