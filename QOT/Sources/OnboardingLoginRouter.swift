//
//  OnboardingLoginRouter.swift
//  QOT
//
//  Created by karmic on 29.07.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class OnboardingLoginRouter: BaseRouter, OnboardingLoginRouterInterface {
    func goToRegister() {
        guard let controller = R.storyboard.registration.registrationViewController() else { return }
        let configurator = RegistrationConfigurator.make()
        configurator(controller)
        viewController?.pushToStart(childViewController: controller)
    }
}
