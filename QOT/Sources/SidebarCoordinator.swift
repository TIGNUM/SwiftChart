//
//  SidebarCoordinator.swift
//  QOT
//
//  Created by karmic on 21/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

final class SidebarCoordinator: ParentCoordinator {

    private let services: Services
    private let rootViewController: UIViewController
    private let networkManager: NetworkManager
    private let syncManager: SyncManager
    private let permissionsManager: PermissionsManager
    private let destination: AppCoordinator.Router.Destination?
    private let sidebarViewModel: SidebarViewModel
    let sideBarViewController: SidebarViewController!
    var topTabBarController: UINavigationController?
    var children = [Coordinator]()

    init(root: UIViewController,
         services: Services,
         syncManager: SyncManager,
         networkManager: NetworkManager,
         permissionsManager: PermissionsManager,
         destination: AppCoordinator.Router.Destination?) {
        self.rootViewController = root
        self.services = services
        self.networkManager = networkManager
        self.syncManager = syncManager
        self.permissionsManager = permissionsManager
        self.destination = destination
        sidebarViewModel = SidebarViewModel(services: services)
        sideBarViewController = SidebarViewController(viewModel: sidebarViewModel)
        topTabBarController = UINavigationController(withPages: [sideBarViewController],
                                                     navigationItem: NavigationItem(),
                                                     topBarDelegate: self,
                                                     leftButton: UIBarButtonItem(withImage: R.image.ic_close()),
                                                     rightButton: UIBarButtonItem(withImage: R.image.ic_logo()))
        topTabBarController?.modalTransitionStyle = .crossDissolve
        sideBarViewController.delegate = self
    }

    func start() {
        guard let topTabBarController = self.topTabBarController else { return }
        rootViewController.present(topTabBarController, animated: true)
    }
}

// MARK: - SidebarViewControllerDelegate

extension SidebarCoordinator: SidebarViewControllerDelegate {

    func didTapSettingsCell(in viewController: SidebarViewController) {
        let configurator = SettingsConfigurator.make()
		let settingsViewController = SettingsViewController(configure: configurator, services: services)
        settingsViewController.navigationItem.backBarButtonItem = UIBarButtonItem(title: "",
                                                                                  style: .plain,
                                                                                  target: nil,
                                                                                  action: nil)
        let navController = UINavigationController(rootViewController: settingsViewController)
        navController.navigationBar.applyDefaultStyle()
        navController.modalTransitionStyle = .crossDissolve
        navController.modalPresentationStyle = .custom
        viewController.pushToStart(childViewController: settingsViewController)
    }

    func didTapCalendarCell(in viewController: SidebarViewController) {
        didTapSettingsCell(in: viewController)

        let calendarsViewModel = SettingsCalendarListViewModel(services: services)
        let calendarsViewController = SettingsCalendarListViewController(viewModel: calendarsViewModel)
        viewController.pushToStart(childViewController: calendarsViewController)
    }

    func didTapAdminCell(in viewController: SidebarViewController) {
        let coordinator = SettingsAdminCoordinator(root: viewController,
                                                   services: services,
                                                   syncManager: syncManager,
                                                   networkManager: networkManager)
        startChild(child: coordinator)
    }

    func didTapSearchCell(in viewController: SidebarViewController) {
        let configurator = SearchConfigurator.make()
        let searchViewController = SearchViewController(configure: configurator)
        let navController = UINavigationController(rootViewController: searchViewController)
        navController.navigationBar.applyDefaultStyle()
        navController.modalTransitionStyle = .crossDissolve
        navController.modalPresentationStyle = .custom
        viewController.pushToStart(childViewController: searchViewController)
    }

    func didTapSupportCell(in viewController: SidebarViewController) {
        let configurator = SettingsBubblesConfigurator.make(type: .support)
        let bubblesViewController = SettingsBubblesViewController(configurator: configurator, settingsType: .support)
        let navController = UINavigationController(rootViewController: bubblesViewController)
        navController.navigationBar.applyDefaultStyle()
        navController.modalTransitionStyle = .crossDissolve
        navController.modalPresentationStyle = .custom
        viewController.pushToStart(childViewController: bubblesViewController)
    }

    func didTapProfileCell(with contentCollection: ContentCollection?,
                           in viewController: SidebarViewController,
                           options: [LaunchOption: String?]? = nil) {
        let configurator = ProfileSettingsConfigurator.make()
        guard
            let menuViewModel = SettingsMenuViewModel(services: services),
            let settingsViewModel = SettingsViewModel(services: services, settingsType: .profile) else { return }
        let profileViewController = ProfileSettingsViewController(configurator: configurator,
                                                                  services: services,
                                                                  permissionsManager: permissionsManager,
                                                                  networkManager: networkManager,
                                                                  settingsMenuViewModel: menuViewModel,
                                                                  settingsViewModel: settingsViewModel,
                                                                  launchOptions: options)
        let navController = UINavigationController(rootViewController: profileViewController)
        navController.navigationBar.applyDefaultStyle()
        navController.modalTransitionStyle = .crossDissolve
        navController.modalPresentationStyle = .custom
        viewController.pushToStart(childViewController: profileViewController)
    }

    func didTapLibraryCell(in viewController: SidebarViewController) {
        let coordinator = LibraryCoordinator(root: viewController, services: services)
        startChild(child: coordinator)
    }

    func didTapAboutCell(in viewController: SidebarViewController) {
        let configurator = SettingsBubblesConfigurator.make(type: .about)
        let bubblesViewController = SettingsBubblesViewController(configurator: configurator, settingsType: .about)
        let navController = UINavigationController(rootViewController: bubblesViewController)
        navController.navigationBar.applyDefaultStyle()
        navController.modalTransitionStyle = .crossDissolve
        navController.modalPresentationStyle = .custom
        viewController.pushToStart(childViewController: bubblesViewController)
    }

    private func startSidebarItemCoordinator(pageName: PageName, contentCollection: ContentCollection?, viewController: UIViewController, topTabBarTitle: String? = nil, backgroundImage: UIImage? = nil) {
        guard let coordinator = ArticleContentItemCoordinator(pageName: pageName,
                                                              root: viewController,
                                                              services: services,
                                                              contentCollection: contentCollection,
                                                              topTabBarTitle: topTabBarTitle?.uppercased(),
                                                              backgroundImage: backgroundImage) else { return }
        startChild(child: coordinator)
    }
}

// MARK: - TopNavigationBarDelegate

extension SidebarCoordinator: NavigationItemDelegate {
    func navigationItem(_ navigationItem: NavigationItem, leftButtonPressed button: UIBarButtonItem) {
        topTabBarController?.dismiss(animated: true, completion: nil)
        removeChild(child: self)
    }

    func navigationItem(_ navigationItem: NavigationItem, middleButtonPressedAtIndex index: Int, ofTotal total: Int) {}

    func navigationItem(_ navigationItem: NavigationItem, rightButtonPressed button: UIBarButtonItem) {}

    func navigationItem(_ navigationItem: NavigationItem, searchButtonPressed button: UIBarButtonItem) {}
}
