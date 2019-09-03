//
//  NotificationPermissionRouter.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 14/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class NotificationPermissionRouter {

    // MARK: - Properties

    private let viewController: NotificationPermissionViewController

    // MARK: - Init

    init(viewController: NotificationPermissionViewController) {
        self.viewController = viewController
    }
}

// MARK: - LocationPermissionRouterInterface

extension NotificationPermissionRouter: NotificationPermissionRouterInterface {
    func dismiss() {
        viewController.didTapDismissButton()
    }

    func openSettings() {
        UIApplication.openAppSettings()
    }
}
