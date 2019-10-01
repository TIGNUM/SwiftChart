//
//  RegistrationAgeRouter.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 14/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class RegistrationAgeRouter {

    // MARK: - Properties

    private weak var viewController: RegistrationAgeViewController?

    // MARK: - Init

    init(viewController: RegistrationAgeViewController) {
        self.viewController = viewController
    }
}

// MARK: - RegistrationAgeRouterInterface

extension RegistrationAgeRouter: RegistrationAgeRouterInterface {

}
