//
//  SettingsCalendarListCoordinator.swift
//  QOT
//
//  Created by karmic on 25.07.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

final class SettingsCalendarListCoordinator: ParentCoordinator {

    fileprivate let rootViewController: SettingsViewController
    fileprivate let services: Services
    fileprivate var topTabBarController: UINavigationController!
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
        rootViewController.presentRightToLeft(controller: topTabBarController)
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
