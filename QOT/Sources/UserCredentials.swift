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

final class CredentialsManager {

    // MARK: - Properties

    private let keychain = Keychain()
    private var credentialDidChangeHandlers: [(Credential?) -> Void] = []
    static let shared = CredentialsManager()

    // MARK: - Init

    private init() {} // Ensure only singleton instance is used

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

            let handlers = credentialDidChangeHandlers
            DispatchQueue.main.async {
                handlers.forEach { $0(newValue) }
            }
        }
    }

    var isCredentialValid: Bool {
        guard let credential = credential else {
            return false
        }
        return (credential.token != nil)
    }

    func clear() {
        credential = nil
    }

    func onCredentialChange(_ handler: @escaping (Credential?) -> Void) {
        credentialDidChangeHandlers.append(handler)
    }

    // MARK: - private

    private func value(key: KeychainConstant) -> String? {
        do {
            return try keychain.getString(key.rawValue)
        } catch {
            log("Failed to get \(key.rawValue) from keychain: \(error)", level: .error)
            return nil
        }
    }

    private func set(value: String?, key: KeychainConstant) {
        do {
            if let value =  value {
                try keychain.set(value, key: key.rawValue)
            } else {
                try keychain.remove(key.rawValue)
            }
        } catch {
            log("Failed to set value for \(key.rawValue) in keychain: \(error)", level: .error)
        }
    }
}
