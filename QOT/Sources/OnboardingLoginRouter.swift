//
//  OnboardingLoginRouter.swift
//  QOT
//
//  Created by karmic on 29.07.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class OnboardingLoginRouter {

    // MARK: - Properties

    private let viewController: OnboardingLoginViewController

    // MARK: - Init

    init(viewController: OnboardingLoginViewController) {
        self.viewController = viewController
    }
}

// MARK: - OnoardingLoginRouterInterface

extension OnboardingLoginRouter: OnboardingLoginRouterInterface {
    func showHomeScreen() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.appCoordinator.showApp()
    }
}
