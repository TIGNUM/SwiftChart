//
//  SigningDigitWorker.swift
//  QOT
//
//  Created by karmic on 07.06.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import UIKit
import MBProgressHUD

final class SigningDigitWorker {

    // MARK: - Properties

    private let services: Services
    private let networkManager: NetworkManager
    let email: String
    var code = ""

    // MARK: - Init

    init(services: Services, networkManager: NetworkManager, email: String) {
        self.services = services
        self.networkManager = networkManager
        self.email = email
    }
}

extension SigningDigitWorker {

    func verify(code: String, completion: ((UserRegistrationCheck?) -> Void)?) {
        guard let window = AppDelegate.current.window else {
                completion?(nil)
                return
        }
        self.code = code
        let progressHUD = MBProgressHUD.showAdded(to: window, animated: true)
        networkManager.performUserDigitCodeCheckRequest(email: email,
                                                        code: code) { (result) in
                                                            progressHUD.hide(animated: true)
                                                            completion?(result.value)
        }
    }
}
