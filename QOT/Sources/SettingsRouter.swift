//
//  SettingsRouter.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 26/04/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

final class SettingsRouter {

    private let settingsViewController: SettingsViewController
	private let services: Services

	init(settingsViewController: SettingsViewController, services: Services) {
        self.settingsViewController = settingsViewController
		self.services = services
    }
}

// MARK: - SettingsRouterInterface

extension SettingsRouter: SettingsRouterInterface {

    func handleTap(setting: SettingsModel.Setting) {
        switch setting {
        case .calendars:
            let viewModel = SettingsCalendarListViewModel(services: services)
            let calendarListViewController = SettingsCalendarListViewController(viewModel: viewModel)
            settingsViewController.pushToStart(childViewController: calendarListViewController)
        case .notifications:
            settingsViewController.showAlert(type: .changeNotifications, handler: {
                UIApplication.openAppSettings()
            }, handlerDestructive: nil)
        case .permissions:
            let configurator = PermissionsConfigurator.make()
            let permissionsViewController = PermissionsViewController(configure: configurator)
            settingsViewController.pushToStart(childViewController: permissionsViewController)
        case .sensors:
            let configurator = SensorConfigurator.make()
            let sensorViewController = SensorViewController(configure: configurator)
            settingsViewController.pushToStart(childViewController: sensorViewController)
        }
    }
}
