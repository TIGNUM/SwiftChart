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

    func openCreatePasswordView(userSigning: UserSigning,
                                responseType: UserRegistrationCheck.ResponseType) {
        guard AppDelegate.topViewController() is SigningDigitViewController else { return }
        let configurator = SigningCreatePasswordConfigurator.make(userSigning: userSigning,
                                                                  responseType: responseType)
        let controller = SigningCreatePasswordViewController(configure: configurator)
        controller.navigationItem.hidesBackButton = true
        viewController.pushToStart(childViewController: controller)
    }
}
