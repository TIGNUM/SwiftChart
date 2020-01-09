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
        if let controller = R.storyboard.registerIntro().instantiateInitialViewController() as? RegisterIntroViewController {
            let configurator = RegisterIntroConfigurator.make()
            configurator(controller)
            viewController?.pushToStart(childViewController: controller)
        }
    }
}
