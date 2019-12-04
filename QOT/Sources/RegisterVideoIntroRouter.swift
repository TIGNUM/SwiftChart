//
//  RegisterVideoIntroRouter.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 29/11/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class RegisterVideoIntroRouter {

    // MARK: - Properties
    private weak var viewController: RegisterVideoIntroViewController?

    // MARK: - Init
    init(viewController: RegisterVideoIntroViewController?) {
        self.viewController = viewController
    }
}

// MARK: - RegisterVideoIntroRouterInterface
extension RegisterVideoIntroRouter: RegisterVideoIntroRouterInterface {
    func openRegistration() {
        guard let controller = R.storyboard.registration.registrationViewController() else { return }
        let configurator = RegistrationConfigurator.make()
        configurator(controller)
        viewController?.pushToStart(childViewController: controller)
    }
}
