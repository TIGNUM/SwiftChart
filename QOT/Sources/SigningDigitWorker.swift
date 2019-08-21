//
//  SigningDigitWorker.swift
//  QOT
//
//  Created by karmic on 07.06.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import UIKit
import SVProgressHUD

final class SigningDigitWorker {

    // MARK: - Properties

    private let services: Services
    private let networkManager: NetworkManager
    let email: String
    var code: String?

    // MARK: - Init

    init(services: Services, networkManager: NetworkManager, email: String, code: String?) {
        self.services = services
        self.networkManager = networkManager
        self.email = email
        self.code = code
    }
}

// MARK: - Public

extension SigningDigitWorker {

    func verify(code: String, completion: ((UserRegistrationCheck?) -> Void)?) {
        self.code = code
        SVProgressHUD.show()
        networkManager.performUserDigitCodeCheckRequest(email: email,
                                                        code: code) { (result) in
                                                            SVProgressHUD.dismiss()
                                                            completion?(result.value)
        }
    }
}
