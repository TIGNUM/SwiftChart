//
//  RegistrationEmailRouter.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 08/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class RegistrationEmailRouter {

    // MARK: - Properties
    private weak var viewController: RegistrationEmailViewController?

    // MARK: - Init
    init(viewController: RegistrationEmailViewController) {
        self.viewController = viewController
    }
}

// MARK: - RegistrationEmailRouterInterface
extension RegistrationEmailRouter: RegistrationEmailRouterInterface { }
