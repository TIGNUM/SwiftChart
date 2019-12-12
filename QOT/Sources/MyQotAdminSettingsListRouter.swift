//
//  MyQotAdminSettingsListRouter.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 12/12/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class MyQotAdminSettingsListRouter {

    // MARK: - Properties
    private weak var viewController: MyQotAdminSettingsListViewController?

    // MARK: - Init
    init(viewController: MyQotAdminSettingsListViewController?) {
        self.viewController = viewController
    }
}

// MARK: - MyQotAdminSettingsListRouterInterface
extension MyQotAdminSettingsListRouter: MyQotAdminSettingsListRouterInterface {
    func dismiss() {
        viewController?.dismiss(animated: true, completion: nil)
    }
}
