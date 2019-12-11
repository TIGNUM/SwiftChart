//
//  RegistrationRouter.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 08/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class RegistrationRouter {

    // MARK: - Properties
    private weak var viewController: RegistrationViewController?

    // MARK: - Init
    init(viewController: RegistrationViewController) {
        self.viewController = viewController
    }
}

// MARK: - RegistrationRouterInterface
extension RegistrationRouter: RegistrationRouterInterface {
    func popBack() {
        viewController?.navigationController?.popViewController(animated: true)
    }

    func showCoachMarksViewController() {
        let configurator = CoachMarksConfigurator.make()
        let controller = R.storyboard.coachMark.coachMarksViewController() ?? CoachMarksViewController()
        configurator(controller)
        viewController?.pushToStart(childViewController: controller)
    }
}
