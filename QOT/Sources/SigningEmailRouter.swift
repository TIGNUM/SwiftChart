//
//  SigningEmailRouter.swift
//  QOT
//
//  Created by karmic on 29.05.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import UIKit

final class SigningEmailRouter {

    // MARK: - Properties

    private let viewController: SigningEmailViewController

    // MARK: - Init

    init(viewController: SigningEmailViewController) {
        self.viewController = viewController
    }
}

// MARK: - SigningEmailRouterInterface

extension SigningEmailRouter: SigningEmailRouterInterface {

    func openDigitVerificationView(email: String) {
        guard AppDelegate.topViewController() is SigningEmailViewController else { return }
        let configurator = SigningDigitConfigurator.make(email: email, code: nil)
        let controller = SigningDigitViewController(configure: configurator)
        viewController.pushToStart(childViewController: controller)
    }

    func openSignInView(email: String) {
        guard AppDelegate.topViewController() is SigningEmailViewController else { return }
        let configurator = SigningLoginConfigurator.make(email: email)
        let controller = SigningLoginViewController(configure: configurator)
        viewController.pushToStart(childViewController: controller)
    }

    func open(_ url: URL, message: String?) {
        viewController.showAlert(type: .message(message ?? ""), handler: {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }, handlerDestructive: nil)
    }
}
