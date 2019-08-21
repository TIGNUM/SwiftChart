//
//  RegistrationPresenter.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 08/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class RegistrationPresenter {

    // MARK: - Properties
    var navigationController: UINavigationController {
        return viewController?.navigationController ?? UINavigationController()
    }

    private weak var viewController: RegistrationViewControllerInterface?

    // MARK: - Init

    init(viewController: RegistrationViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - RegistrationInterface

extension RegistrationPresenter: RegistrationPresenterInterface {
    func setupView() {
        viewController?.setupView()
    }

    func presentView() {
        viewController?.updateView()
    }

    func present(controller: UIViewController, direction: UIPageViewController.NavigationDirection) {
        viewController?.update(controller: controller, direction: direction)
    }

    func presentActivity(state: ActivityState?) {
        viewController?.presentActivity(state: state)
    }

    func presentAlert(message: String) {
        viewController?.showAlert(message: message)
    }
}
