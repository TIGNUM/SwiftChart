//
//  Keychain.swift
//  QOT
//
//  Created by Sam Wyndham on 01/02/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation
import KeychainAccess

final class Keychain {

    private let keychain: KeychainAccess.Keychain

    init(keychain: KeychainAccess.Keychain = KeychainAccess.Keychain()) {
        self.keychain = keychain
    }

    public subscript(string key: KeychainConstant) -> String? {
        get {
            do {
                return try keychain.getString(key.rawValue)
            } catch {
                logGetError(key: key, error: error)
                return nil
            }
        }
        set {
            do {
                if let value = newValue {
                    try keychain.set(value, key: key.rawValue)
                } else {
                    try keychain.remove(key.rawValue)
                }
            } catch {
                logSetError(key: key, error: error)
            }
        }
    }

    public subscript(data key: KeychainConstant) -> Data? {
        get {
            do {
                return try keychain.getData(key.rawValue)
            } catch {
                logGetError(key: key, error: error)
                return nil
            }
        }
        set {
            do {
                if let value = newValue {
                    try keychain.set(value, key: key.rawValue)
                } else {
                    try keychain.remove(key.rawValue)
                }
            } catch {
                logSetError(key: key, error: error)
            }
        }
    }

    private func logSetError(key: KeychainConstant, error: Error) {
        log("Failed to set value in keychain. Key: \(key.rawValue) Error: \(error)", level: .error)
    }

    private func logGetError(key: KeychainConstant, error: Error) {
        log("Failed to get value from keychain. Key: \(key.rawValue) Error: \(error)", level: .error)
    }
}
