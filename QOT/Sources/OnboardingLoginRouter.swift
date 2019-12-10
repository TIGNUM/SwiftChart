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

    private weak var viewController: OnboardingLoginViewController?

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

    func showFAQScreen() {
        let identifier = R.storyboard.myQot.myQotSupportDetailsViewController.identifier
        if let controller = R.storyboard
            .myQot().instantiateViewController(withIdentifier: identifier) as? MyQotSupportDetailsViewController {
            MyQotSupportDetailsConfigurator.configure(viewController: controller, category: .FAQBeforeLogin)
            viewController?.present(controller, animated: true, completion: nil)
        }
    }

    func showCoachMarks() {
        guard let controller = R.storyboard.coachMark.coachMarksViewController() else { return }
        let configurator = CoachMarksConfigurator.make()
        configurator(controller)
        viewController?.pushToStart(childViewController: controller)
    }

    func goToRegister() {
        if let controller = R.storyboard.registerIntro().instantiateInitialViewController() as? RegisterIntroViewController {
            let configurator = RegisterIntroConfigurator.make()
            configurator(controller)
            viewController?.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
