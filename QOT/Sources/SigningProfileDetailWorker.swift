//
//  SigningProfileDetailWorker.swift
//  QOT
//
//  Created by karmic on 12.06.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import UIKit

final class SigningProfileDetailWorker {

    // MARK: - Properties

    private let services: Services
    private let networkManager: NetworkManager
    private let syncManager: SyncManager
    var userSigning: UserSigning
    var checkBoxIsChecked = false

    // MARK: - Init

    init(services: Services,
         networkManager: NetworkManager,
         syncManager: SyncManager,
         userSigning: UserSigning) {
        self.services = services
        self.networkManager = networkManager
        self.syncManager = syncManager
        self.userSigning = userSigning
    }
}

extension SigningProfileDetailWorker {

    func createAccount(completion: ((UserRegistrationCheck?, Error?) -> Void)?) {
        _ = networkManager.performRegistrationRequest(email: userSigning.email ?? "",
                                                      code: userSigning.verificationCode ?? "",
                                                      gender: (userSigning.gender ?? "").replacingOccurrences(of: " ",
                                                                                                              with: "_").uppercased(),
                                                      firstName: userSigning.firstName ?? "",
                                                      lastName: userSigning.lastName ?? "",
                                                      birthDate: userSigning.birthdate ?? "",
                                                      password: userSigning.password ?? "",
                                                      countryID: userSigning.country?.id ?? 0) { (result) in
                                                        if result.error != nil {
                                                            completion?(result.value, result.error)
                                                        } else {
                                                            self.sendLoginRequest(email: self.userSigning.email ?? "",
                                                                                  password: self.userSigning.password ?? "",
                                                                                  completion: { (error) in
                                                                                    completion?(result.value, error)
                                                            })
                                                        }
        }
    }

    func activateButton() -> Bool {
        return
            userSigning.firstName?.isEmpty == false &&
            userSigning.lastName?.isEmpty == false &&
            userSigning.birthdate?.isEmpty == false &&
            userSigning.gender?.isEmpty == false &&
            checkBoxIsChecked == true
    }
}

// MARK: - Private

private extension SigningProfileDetailWorker {

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

    func downSyncUser(completion: ((_ error: Error?) -> Void)?) {
        self.syncManager.downSyncUser { (downSyncError) in
            completion?(downSyncError)
        }
    }
}
