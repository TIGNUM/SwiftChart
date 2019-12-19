//
//  MyQotAdminDCSixthQuestionSettingsRouter.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 12/12/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class MyQotAdminDCSixthQuestionSettingsRouter {

    // MARK: - Properties
    private weak var viewController: MyQotAdminDCSixthQuestionSettingsViewController?

    // MARK: - Init
    init(viewController: MyQotAdminDCSixthQuestionSettingsViewController?) {
        self.viewController = viewController
    }
}

// MARK: - MyQotAdminDCSixthQuestionSettingsRouterInterface
extension MyQotAdminDCSixthQuestionSettingsRouter: MyQotAdminDCSixthQuestionSettingsRouterInterface {
    func dismiss() {
        viewController?.dismiss(animated: true, completion: nil)
    }
}
