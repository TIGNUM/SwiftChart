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

    // MARK: - Init

    init(viewController: MyQotAppSettingsViewController) {
        self.viewController = viewController
    }
}

// MARK: - MyQotAppSettingsRouterInterface

extension MyQotAppSettingsRouter: MyQotAppSettingsRouterInterface {

    func openAppSettings() {
        viewController.showAlert(type: .changeNotifications, handler: {
            UIApplication.openAppSettings()
        }, handlerDestructive: nil)
    }

    func openCalendarSettings() {
        viewController.performSegue(withIdentifier: R.segue.myQotAppSettingsViewController.myQotAppSettingsSyncedCalendarSegueIdentifier, sender: nil)
    }

    func openActivityTrackerSettings() {
        viewController.performSegue(withIdentifier: R.segue.myQotAppSettingsViewController.myQotAppSettingsActivityTrackerSegueIdentifier, sender: nil)
    }

    func openSiriSettings() {
        viewController.performSegue(withIdentifier: R.segue.myQotAppSettingsViewController.myQotAppSettingsSiriShortcutsSegueIdentifier, sender: nil)
    }

    func openCalendarPermission(_ type: AskPermission.Kind, delegate: AskPermissionDelegate) {
        guard let controller = R.storyboard.askPermission().instantiateInitialViewController() as? AskPermissionViewController else {
            return
        }
        AskPermissionConfigurator.make(viewController: controller, type: type, delegate: delegate)
        viewController.present(controller, animated: true, completion: nil)
    }
}
