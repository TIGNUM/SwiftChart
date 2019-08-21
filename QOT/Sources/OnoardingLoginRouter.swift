//
//  OnoardingLoginRouter.swift
//  QOT
//
//  Created by karmic on 29.07.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class OnoardingLoginRouter {

    // MARK: - Properties

    private let viewController: OnoardingLoginViewController

    // MARK: - Init

    init(viewController: OnoardingLoginViewController) {
        self.viewController = viewController
    }
}

// MARK: - OnoardingLoginRouterInterface

extension OnoardingLoginRouter: OnoardingLoginRouterInterface {

}
