//
//  SigningEmailWorker.swift
//  QOT
//
//  Created by karmic on 29.05.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import UIKit
import MBProgressHUD

final class SigningEmailWorker {

    // MARK: - Properties

    private let services: Services
    private let networkManager: NetworkManager
    var email: String?

    // MARK: - Init

    init(services: Services, networkManager: NetworkManager) {
        self.services = services
        self.networkManager = networkManager
    }
}

// MARK: - Public

extension SigningEmailWorker {

    var isEmail: Bool {
        return email?.isEmail ?? false
    }

    func userEmailCheck(completion: ((UserRegistrationCheck?) -> Void)?) {
        guard
            let window = AppDelegate.current.window,
            let email = email else {
                completion?(nil)
                return
        }
        let progressHUD = MBProgressHUD.showAdded(to: window, animated: true)
        networkManager.performUserEmailCheckRequest(email: email) { (result) in
            progressHUD.hide(animated: true)
            completion?(result.value)
        }
    }
}
