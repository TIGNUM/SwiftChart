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
        guard let coachCollectionViewController = R.storyboard.main.coachCollectionViewController() else { return }
        baseRootViewController?.setContent(viewController: coachCollectionViewController)
        baseRootViewController?.dismiss(animated: true, completion: nil)
    }
}
