//
//  RegistrationNamesRouter.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 12/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class RegistrationNamesRouter {

    // MARK: - Properties

    private let viewController: RegistrationNamesViewController

    // MARK: - Init

    init(viewController: RegistrationNamesViewController) {
        self.viewController = viewController
    }
}

// MARK: - RegistrationNamesRouterInterface

extension RegistrationNamesRouter: RegistrationNamesRouterInterface {

}
