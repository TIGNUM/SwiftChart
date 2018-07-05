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
    let email: String
    let password: String
    let country: UserCountry
    let code: String
    var firstName = ""
    var lastName = ""
    var dateOfBirth = ""
    var gender = ""
    var checkBoxIsChecked = false

    // MARK: - Init

    init(services: Services,
         networkManager: NetworkManager,
         syncManager: SyncManager,
         email: String,
         code: String,
         password: String,
         country: UserCountry) {
        self.services = services
        self.networkManager = networkManager
        self.syncManager = syncManager
        self.email = email
        self.code = code
        self.password = password
        self.country = country
    }
}

extension SigningProfileDetailWorker {

    func createAccount(completion: ((UserRegistrationCheck?, Error?) -> Void)?) {
        _ = networkManager.performRegistrationRequest(email: email,
                                                      code: code,
                                                      gender: gender.replacingOccurrences(of: " ", with: "_").uppercased(),
                                                      firstName: firstName,
                                                      lastName: lastName,
                                                      birthDate: dateOfBirth,
                                                      password: password,
                                                      country: country) { (result) in
                                                        if result.error != nil {
                                                            completion?(result.value, result.error)
                                                        } else {
                                                            self.sendLoginRequest(email: self.email,
                                                                                  password: self.password,
                                                                                  completion: { (error) in
                                                                                    completion?(result.value, error)
                                                            })
                                                        }
        }
    }

    func activateButton() -> Bool {
        return
            firstName.isEmpty == false &&
            lastName.isEmpty == false &&
            dateOfBirth.isEmpty == false &&
            gender.isEmpty == false &&
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
