//
//  SettingsCalendarListCoordinator.swift
//  QOT
//
//  Created by karmic on 25.07.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit
import EventKit

final class SettingsCalendarListCoordinator: ParentCoordinator {

    fileprivate let rootViewController: SettingsViewController
    fileprivate let services: Services
    fileprivate var topTabBarController: UINavigationController!
    fileprivate lazy var permissionHandler: PermissionHandler = PermissionHandler()
    var children = [Coordinator]()

    init(root: SettingsViewController, services: Services) {
        self.rootViewController = root
        self.services = services
        let viewModel = SettingsCalendarListViewModel(services: services)
        let settingsCalendarListViewController = SettingsCalendarListViewController(viewModel: viewModel)
        settingsCalendarListViewController.title = R.string.localized.settingsGeneralCalendarTitle()
        let leftButton = UIBarButtonItem(withImage: R.image.ic_back())
        topTabBarController = UINavigationController(withPages: [settingsCalendarListViewController], topBarDelegate: self, leftButton: leftButton)
    }

    func start() {
        permissionHandler.askPermissionForCalendar { (garanted: Bool) in
            switch garanted {
            case true: self.rootViewController.presentRightToLeft(controller: self.topTabBarController)
            case false: self.rootViewController.showAlert(type: .settingsCalendars, handler: { 
                    UIApplication.openAppSettings()
                }, handlerDestructive: nil)
            }
        }
    }
}

// MARK: - TopNavigationBarDelegate

extension SettingsCalendarListCoordinator: TopNavigationBarDelegate {

    func topNavigationBar(_ navigationBar: TopNavigationBar, leftButtonPressed button: UIBarButtonItem) {
        topTabBarController.dismissLeftToRight()
    }

    func topNavigationBar(_ navigationBar: TopNavigationBar, middleButtonPressed button: UIButton, withIndex index: Int, ofTotal total: Int) {}

    func topNavigationBar(_ navigationBar: TopNavigationBar, rightButtonPressed button: UIBarButtonItem) {}
}
