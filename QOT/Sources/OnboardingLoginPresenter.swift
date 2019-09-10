//
//  OnboardingLoginPresenter.swift
//  QOT
//
//  Created by karmic on 29.07.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class OnboardingLoginPresenter {

    // MARK: - Properties
    private weak var viewController: OnboardingLoginViewControllerInterface?

    // MARK: - Init
    init(viewController: OnboardingLoginViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - OnoardingLoginInterface
extension OnboardingLoginPresenter: OnboardingLoginPresenterInterface {
    func setupView() {
        viewController?.setupView()
    }

    func present() {
        viewController?.updateView()
    }

    func presentActivity(state: ActivityState?) {
        viewController?.presentActivity(state: state)
    }

    func presentCodeEntry() {
        viewController?.beginCodeEntry()
    }

    func presentGetHelp() {
        viewController?.presentGetHelpView()
    }

    func presentUnoptimizedAlertView() {
        viewController?.presentUnoptimizedAlertView()
    }
}
