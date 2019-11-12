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
    private weak var delegate: AskPermissionDelegate?

    // MARK: - Init
    init(viewController: AskPermissionViewController?, delegate: AskPermissionDelegate?) {
        self.viewController = viewController
        self.delegate = delegate
    }
}

// MARK: - AskPermissionRouterInterface
extension AskPermissionRouter: AskPermissionRouterInterface {

    func didTapDismiss(_ permissionType: AskPermission.Kind) {
        dismiss(type: permissionType, granted: false)
    }

    func didTapConfirm(_ permissionType: AskPermission.Kind) {
        requestAccess(permissionType)
    }
}

// MARK: - Request Permission
private extension AskPermissionRouter {
    func requestAccess(_ permissionType: AskPermission.Kind) {
        switch permissionType {
        case .location:
            requestLocationAccess(permissionType)
        case .notification, .notificationOnboarding:
            requestNotificationAccess(permissionType)
        case .calendar:
            requestCalendarAccess(permissionType)
        case .calendarOpenSettings,
             .notificationOpenSettings:
            openSystemSettings(permissionType)
        }
    }

    func requestLocationAccess(_ type: AskPermission.Kind) {
        LocationPermission().askPermission { [weak self] (granted) in
            self?.dismiss(type: type, granted: granted)
        }
    }

    func requestCalendarAccess(_ type: AskPermission.Kind) {
        CalendarPermission().askPermission { [weak self] (granted) in
            self?.dismiss(type: type, granted: granted)
        }
    }

    func requestNotificationAccess(_ type: AskPermission.Kind) {
        RemoteNotificationPermission().askPermission { [weak self] (granted) in
            self?.dismiss(type: type, granted: granted)
        }
    }

    func openSystemSettings(_ type: AskPermission.Kind) {
        dismiss(type: type, granted: false)
        UIApplication.openAppSettings()
    }
}

// MARK: - Private func

private extension AskPermissionRouter {

    func dismiss(type: AskPermission.Kind, granted: Bool) {
        DispatchQueue.main.async {
            if granted == true {
                self.viewController?.dismiss(animated: true) {
                    self.delegate?.didFinishAskingForPermission(type: type, granted: granted)
                }
            } else {
                self.delegate?.didFinishAskingForPermission(type: type, granted: granted)
                self.viewController?.dismiss(animated: true)
            }
        }
    }
}
