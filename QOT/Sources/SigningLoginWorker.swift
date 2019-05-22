//
//  SigningLoginWorker.swift
//  QOT
//
//  Created by karmic on 05.06.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import UIKit
import qot_dal
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
        let authenticator = Authenticator()
        authenticator.authenticate(username: email.trimmed, password: password.trimmed) { [weak self] (result) in
            switch result {
            case .failure(let error):
                completion?(error)
            case .success(let _):
                ExtensionsDataManager.didUserLogIn(true)
                self?.downSyncUser(completion: completion)
            }
        }
    }

    func sendResetPassword(completion: @escaping (NetworkError?) -> Void) {
        QOTService.main.resetPassword(email.trimmed) { (request, requestError) in
            completion(requestError?.networkError)
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
