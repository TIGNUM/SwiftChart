//
//  OnboardingLandingPagePresenter.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 02/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class OnboardingLandingPagePresenter {

    // MARK: - Properties

    private weak var viewController: OnboardingLandingPageViewControllerInterface?

    // MARK: - Init

    init(viewController: OnboardingLandingPageViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - OnboardingLandingPageInterface

extension OnboardingLandingPagePresenter: OnboardingLandingPagePresenterInterface {
    func present(controller: UIViewController, direction: UIPageViewController.NavigationDirection) {
        viewController?.update(controller: controller, direction: direction)
    }
}
