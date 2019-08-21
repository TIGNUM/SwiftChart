//
//  OnoardingLoginPresenter.swift
//  QOT
//
//  Created by karmic on 29.07.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class OnoardingLoginPresenter {

    // MARK: - Properties
    private weak var viewController: OnoardingLoginViewControllerInterface?

    // MARK: - Init
    init(viewController: OnoardingLoginViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - OnoardingLoginInterface
extension OnoardingLoginPresenter: OnoardingLoginPresenterInterface {
    func setupView() {
        viewController?.setupView()
    }
}
