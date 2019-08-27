//
//  AskPermissionRouter.swift
//  QOT
//
//  Created by karmic on 26.08.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class AskPermissionRouter {

    // MARK: - Properties
    private weak var viewController: AskPermissionViewController?

    // MARK: - Init
    init(viewController: AskPermissionViewController?) {
        self.viewController = viewController
    }
}

// MARK: - AskPermissionRouterInterface
extension AskPermissionRouter: AskPermissionRouterInterface {
    func didTapConfirm(_ permissionType: AskPermission.Kind?) {
        requestAccess(permissionType)
    }
}

// MARK: - Request Permission
private extension AskPermissionRouter {
    func requestAccess(_ permissionType: AskPermission.Kind?) {
        switch permissionType {
        case .location?:
            requestLocationAccess()
        case .notification?:
            print("Reuqest Notidfication Access")
        case .calendar?:
            requestCalendarAccess()
        case .calendarOpenSettings?:
            openSystemSettings()
        case .none:
            preconditionFailure("PermissionType does not exist")
        }
    }

    func requestLocationAccess() {
        LocationPermission().askPermission { [weak self] (granted) in
            if granted == true {
                self?.viewController?.dismiss(animated: true, completion: nil)
            } else {
                self?.viewController?.dismiss(animated: true, completion: nil)
            }
        }
    }

    func requestCalendarAccess() {
        CalendarPermission().askPermission { [weak self] (granted) in
            if granted == true {
                self?.viewController?.dismiss(animated: true, completion: nil)
            } else {
                self?.viewController?.dismiss(animated: true, completion: nil)
            }
        }
    }

    func openSystemSettings() {
        UIApplication.openAppSettings()
    }
}
