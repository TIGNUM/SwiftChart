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

    private weak var viewController: MyQotAppSettingsViewController?

    // MARK: - Init

    init(viewController: MyQotAppSettingsViewController) {
        self.viewController = viewController
    }
}

// MARK: - MyQotAppSettingsRouterInterface

extension MyQotAppSettingsRouter: MyQotAppSettingsRouterInterface {

    func askNotificationPermission() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                switch settings.authorizationStatus {
                case .notDetermined:
                    guard let vc = R.storyboard.askPermission().instantiateInitialViewController(),
                        let controller = vc as? AskPermissionViewController else {
                            self.openAppSettings()
                            return
                    }
                    AskPermissionConfigurator.make(viewController: controller, type: .notification)
                    self.viewController?.present(controller, animated: true, completion: nil)
                default:
                    self.openAppSettings()
                }
            }
        }
    }

    func presentNotificationSettings() {
        viewController?.performSegue(withIdentifier: R.segue.myQotAppSettingsViewController.myQotNotificationSettingsSegueIdentifier, sender: nil)
    }

    func openAppSettings() {
        viewController?.showAlert(type: .changeNotifications, handler: {
            UIApplication.openAppSettings()
        }, handlerDestructive: nil)
    }

    func openCalendarSettings() {
        viewController?.performSegue(withIdentifier: R.segue.myQotAppSettingsViewController.myQotAppSettingsSyncedCalendarSegueIdentifier, sender: nil)
    }

    func openActivityTrackerSettings() {
        viewController?.performSegue(withIdentifier: R.segue.myQotAppSettingsViewController.myQotAppSettingsActivityTrackerSegueIdentifier, sender: nil)
    }

    func openSiriSettings() {
        viewController?.performSegue(withIdentifier: R.segue.myQotAppSettingsViewController.myQotAppSettingsSiriShortcutsSegueIdentifier, sender: nil)
    }

    func openCalendarPermission(_ type: AskPermission.Kind, delegate: AskPermissionDelegate) {
        guard let controller = R.storyboard.askPermission().instantiateInitialViewController() as? AskPermissionViewController else {
            return
        }
        AskPermissionConfigurator.make(viewController: controller, type: type, delegate: delegate)
        viewController?.present(controller, animated: true, completion: nil)
    }
}
