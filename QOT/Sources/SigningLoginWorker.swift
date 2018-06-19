//
//  SigningLoginWorker.swift
//  QOT
//
//  Created by karmic on 05.06.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import UIKit

final class SigningLoginWorker {

    // MARK: - Properties

    private let services: Services
    private let networkManager: NetworkManager
    private let syncManager: SyncManager
    let email: String
    var password = ""

    // MARK: - Init

    init(services: Services,
         networkManager: NetworkManager,
         syncManager: SyncManager,
         email: String) {
        self.services = services
        self.networkManager = networkManager
        self.syncManager = syncManager
        self.email = email
    }
}

extension SigningLoginWorker {

    func sendLoginRequest(email: String, password: String, completion: ((_ error: Error?) -> Void)?) {
        networkManager.performAuthenticationRequest(username: email.trimmed,
                                                    password: password.trimmed) { [weak self] (error) in
            if let error = error {
                completion?(error)
            } else {
                self?.downSyncUser(completion: completion)
            }
        }
    }

    func sendResetPassword(completion: @escaping (NetworkError?) -> Void) {
        networkManager.performResetPasswordRequest(username: email.trimmed) { error in
            completion(error)
        }
    }
}

// MARK: - Private

private extension SigningLoginWorker {

    func downSyncUser(completion: ((_ error: Error?) -> Void)?) {
        self.syncManager.downSyncUser { (downSyncError) in
            completion?(downSyncError)
        }
    }
}
