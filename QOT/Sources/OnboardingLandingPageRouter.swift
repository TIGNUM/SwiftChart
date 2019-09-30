//
//  OnboardingLandingPageRouter.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 02/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class OnboardingLandingPageRouter {

    // MARK: - Properties

    private weak var viewController: OnboardingLandingPageViewController?

    // MARK: - Init

    init(viewController: OnboardingLandingPageViewController) {
        self.viewController = viewController
    }
}

// MARK: - OnboardingLandingPageRouterInterface

extension OnboardingLandingPageRouter: OnboardingLandingPageRouterInterface {
    func openRegistration(with cachedTBV: QDMToBeVision?) {
        guard let controller = R.storyboard.registration.registrationViewController() else { return }
        let configurator = RegistrationConfigurator.make()
        configurator(controller, cachedTBV)
        viewController?.pushToStart(childViewController: controller)
    }

    func popToRoot() {
        viewController?.navigationController?.popToRootViewController(animated: true)
    }

    func showTrackSelection() {
        guard let controller = R.storyboard.trackSelection.trackSelectionViewController() else { return }
        let configurator = TrackSelectionConfigurator.make()
        configurator(controller, TrackSelectionControllerType.registration)
        viewController?.pushToStart(childViewController: controller)
    }
}
