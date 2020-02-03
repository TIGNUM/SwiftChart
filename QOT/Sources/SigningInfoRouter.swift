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

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(goToLogin(notification:)),
                                               name: .registrationShouldShowLogin,
                                               object: nil)
    }
}

// MARK: - Private
private extension SigningInfoRouter {
    @objc func goToLogin(notification: Notification) {
        let email = notification.userInfo?[Notification.Name.RegistrationKeys.email] as? String
        showLogin(OnboardingLoginConfigurator.make(email: email))
    }

    func showLogin(_ loginConfigurator: (OnboardingLoginViewController) -> Void) {
        let loginController = OnboardingLoginViewController()
        loginConfigurator(loginController)
        viewController?.navigationController?.pushViewController(loginController, animated: true)
    }
}

// MARK: - SigningInfoRouterInterface
extension SigningInfoRouter: SigningInfoRouterInterface {
    func goToRegister(fromLogin: Bool) {
        if let controller = R.storyboard.registerIntro().instantiateInitialViewController() as? RegisterIntroViewController {
            let configurator = RegisterIntroConfigurator.make(fromLogin: fromLogin)
            configurator(controller)
            viewController?.navigationController?.pushViewController(controller, animated: true)
        }
    }

    func goToLogin() {
        goToRegister(fromLogin: true)
    }
}
