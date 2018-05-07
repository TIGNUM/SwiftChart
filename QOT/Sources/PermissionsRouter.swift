//
//  PermissionsRouter.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 30/04/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

final class PermissionsRouter {

    private let permissionsViewController: PermissionsViewController
    private let permissionsManager: PermissionsManager

    init(permissionsViewController: PermissionsViewController, permissionsManager: PermissionsManager) {
        self.permissionsViewController = permissionsViewController
        self.permissionsManager = permissionsManager
    }
}

// MARK: - PermissionsRouter Interface

extension PermissionsRouter: PermissionsRouterInterface {

    func didTapPermission(permission: PermissionsManager.Permission.Identifier) {
        permissionsViewController.showAlert(type: .changePermissions, handler: {
            UIApplication.openAppSettings()
        }, handlerDestructive: {
            guard let indexPath = self.permissionsViewController.permissionIndexPath(for: permission) else { return }
            self.permissionsViewController.didCancelSwitch(at: indexPath)
        })
    }
}
