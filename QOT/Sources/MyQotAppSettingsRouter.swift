//
//  MyQotAppSettingsRouter.swift
//  QOT
//
//  Created by Ashish Maheshwari on 10.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class MyQotAppSettingsRouter {

    // MARK: - Properties

    private let viewController: MyQotAppSettingsViewController
    private let services: Services

    // MARK: - Init

    init(viewController: MyQotAppSettingsViewController, services: Services) {
        self.viewController = viewController
        self.services = services
    }
}

// MARK: - MyQotAppSettingsRouterInterface

extension MyQotAppSettingsRouter: MyQotAppSettingsRouterInterface {
    func handleTap(setting: MyQotAppSettingsModel.Setting) {
        switch setting {
        case .notifications:
            viewController.showAlert(type: .changeNotifications, handler: {
                UIApplication.openAppSettings()
            }, handlerDestructive: nil)
        case .permissions:
            viewController.showAlert(type: .changePermissions, handler: {
                UIApplication.openAppSettings()
            }, handlerDestructive: nil)
        case .calendars:
            let calendarPermission = CalendarPermission()
            calendarPermission.askPermission { [weak self] result in
                if result == true {
                    DispatchQueue.main.async {
                        self?.viewController.performSegue(withIdentifier: R.segue.myQotAppSettingsViewController.myQotAppSettingsSyncedCalendarSegueIdentifier, sender: nil)
                    }
                } else {
                    self?.viewController.showAlert(type: .settingsCalendars, handler: {
                        UIApplication.openAppSettings()
                    }, handlerDestructive: nil)
                }
            }
        case .sensors:
            viewController.performSegue(withIdentifier: R.segue.myQotAppSettingsViewController.myQotAppSettingsActivityTrackerSegueIdentifier, sender: nil)
        case .siriShortcuts:
            viewController.performSegue(withIdentifier: R.segue.myQotAppSettingsViewController.myQotAppSettingsSiriShortcutsSegueIdentifier, sender: nil)
        }
    }
}
