//
//  SigningCreatePasswordRouter.swift
//  QOT
//
//  Created by karmic on 07.06.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import UIKit

final class SigningCreatePasswordRouter {

    // MARK: - Properties

    private let viewController: SigningCreatePasswordViewController

    // MARK: - Init

    init(viewController: SigningCreatePasswordViewController) {
        self.viewController = viewController
    }
}

// MARK: - SigningCreatePasswordRouterInterface

extension SigningCreatePasswordRouter: SigningCreatePasswordRouterInterface {

    func showCountryView(email: String, code: String, password: String) {
        let configurator = SigningCountryConfigurator.make(email: email, code: code, password: password)
        let controller = SigningCountryViewController(configure: configurator)
        AppDelegate.current.windowManager.show(controller, animated: true, completion: nil)
    }
}
