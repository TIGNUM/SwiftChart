//
//  MyQotAdminEnvironmentSettingsRouter.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 12/12/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class MyQotAdminEnvironmentSettingsRouter {

    // MARK: - Properties
    private weak var viewController: MyQotAdminEnvironmentSettingsViewController?

    // MARK: - Init
    init(viewController: MyQotAdminEnvironmentSettingsViewController?) {
        self.viewController = viewController
    }
}

// MARK: - MyQotAdminEnvironmentSettingsRouterInterface
extension MyQotAdminEnvironmentSettingsRouter: MyQotAdminEnvironmentSettingsRouterInterface {
    func dismiss() {
        viewController?.dismiss(animated: true, completion: nil)
    }
}
