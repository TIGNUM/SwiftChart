//
//  OnboardingLandingPageConfigurator.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 02/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class OnboardingLandingPageConfigurator {

    static func make() -> (OnboardingLandingPageViewController) -> Void {
        return { (viewController) in
            // Signin controller
            let signinInfoConfigurator = SigningInfoConfigurator.make()
            let signinInfoController = SigningInfoViewController()
            signinInfoConfigurator(signinInfoController, viewController)
            // Onboarding controller
            let onboardingConfigurator = OnboardingLoginConfigurator.make()
            let onboardingController = OnboardingLoginViewController()
            onboardingConfigurator(onboardingController, viewController)

            // Landing classes
            let router = OnboardingLandingPageRouter(viewController: viewController)
            let worker = OnboardingLandingPageWorker(infoController: signinInfoController,
                                                     loginController: onboardingController)
            let presenter = OnboardingLandingPagePresenter(viewController: viewController)
            let interactor = OnboardingLandingPageInteractor(worker: worker, presenter: presenter, router: router)
            viewController.interactor = interactor
        }
    }
}
