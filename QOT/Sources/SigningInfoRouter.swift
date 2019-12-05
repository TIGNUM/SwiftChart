//
//  SigningInfoRouter.swift
//  QOT
//
//  Created by karmic on 28.05.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import UIKit

final class SigningInfoRouter {

    // MARK: - Properties

    private weak var viewController: SigningInfoViewController?

    // MARK: - Init

    init(viewController: SigningInfoViewController) {
        self.viewController = viewController
    }
}

// MARK: - SigningInfoRouterInterface

extension SigningInfoRouter: SigningInfoRouterInterface {
    func goToRegister() {
        if let controller = R.storyboard.registerIntro().instantiateInitialViewController() as? RegisterIntroViewController {
            let configurator = RegisterIntroConfigurator.make()
            configurator(controller)
            viewController?.navigationController?.pushViewController(controller, animated: true)
        }
    }

    func goToLogin() {
        let loginConfigurator = OnboardingLoginConfigurator.make()
        let loginController = OnboardingLoginViewController()
        loginConfigurator(loginController)
        viewController?.navigationController?.pushViewController(loginController, animated: true)
    }
}
