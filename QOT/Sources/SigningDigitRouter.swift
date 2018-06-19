//
//  SigningDigitRouter.swift
//  QOT
//
//  Created by karmic on 07.06.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import UIKit

final class SigningDigitRouter {

    // MARK: - Properties

    private let viewController: SigningDigitViewController

    // MARK: - Init

    init(viewController: SigningDigitViewController) {
        self.viewController = viewController
    }
}

// MARK: - SigningDigitRouterInterface

extension SigningDigitRouter: SigningDigitRouterInterface {

    func openEnterEmailView() {
        let configurator = SigningEmailConfigurator.make()
        let controller = SigningEmailViewController(configure: configurator)
        controller.navigationItem.hidesBackButton = true
        viewController.pushToStart(childViewController: controller)
    }

    func openCreatePasswordView(email: String, code: String) {
        let configurator = SigningCreatePasswordConfigurator.make(email: email, code: code)
        let controller = SigningCreatePasswordViewController(configure: configurator)
        controller.navigationItem.hidesBackButton = true
        viewController.pushToStart(childViewController: controller)
    }
}
