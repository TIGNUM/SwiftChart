//
//  UserCredentials.swift
//  QOT
//
//  Created by karmic on 19.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

final class CredentialsManager {

    // MARK: - Properties

    private let keychain = Keychain()
    private var credentialDidChangeHandlers: [((username: String, password: String)?) -> Void] = []
    static let shared = CredentialsManager()

    // MARK: - Init

    private init() {} // Ensure only singleton instance is used

    func loginCredentials() -> (username: String, password: String)? {
        guard let username = keychain[string: .username], let password = keychain[string: .password] else { return nil }
        return (username: username, password: password)
    }

    func authToken() -> String? {
        return keychain[string: .authToken]
    }

    var hasLoginCredentials: Bool {
        return loginCredentials() != nil
    }

    func save(username: String, password: String, authToken: String) {
        keychain[string: .username] = username
        keychain[string: .password] = password
        save(authToken: authToken)
        loginCredentialsDidChange(credentials: (username: username, password: password))
    }

    func save(authToken: String) {
        keychain[string: .authToken] = authToken
    }

    func clear() {
        keychain[string: .username] = nil
        keychain[string: .password] = nil
        keychain[string: .authToken] = nil
        loginCredentialsDidChange(credentials: nil)
    }

    func onCredentialChange(_ handler: @escaping ((username: String, password: String)?) -> Void) {
        credentialDidChangeHandlers.append(handler)
    }

    private func loginCredentialsDidChange(credentials: (username: String, password: String)?) {
        let handlers = credentialDidChangeHandlers
        DispatchQueue.main.async {
            handlers.forEach { $0(credentials) }
        }
    }
}
