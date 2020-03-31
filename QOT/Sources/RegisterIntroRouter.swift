//
//  RegisterIntroRouter.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 05/12/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class RegisterIntroRouter {

    // MARK: - Properties
    private weak var viewController: RegisterIntroViewController?

    // MARK: - Init
    init(viewController: RegisterIntroViewController?) {
        self.viewController = viewController
    }
}

// MARK: - RegisterIntroRouterInterface
extension RegisterIntroRouter: RegisterIntroRouterInterface {
    func dismiss() {
        viewController?.dismiss(animated: true, completion: nil)
    }

    func openRegistration() {
        let configurator = OnboardingLoginConfigurator.make()
        let loginController = OnboardingLoginViewController()
        configurator(loginController)
        viewController?.pushToStart(childViewController: loginController)
    }
}
