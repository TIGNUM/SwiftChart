//
//  SettingsMenuCoordinator.swift
//  QOT
//
//  Created by karmic on 24.04.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

final class SettingsMenuCoordinator: ParentCoordinator {

    private let services: Services
    private let settingsMenuViewController: SettingsMenuViewController
    private let rootViewController: UIViewController
    private let networkManager: NetworkManager
    private let syncManager: SyncManager
    private let permissionsManager: PermissionsManager
    var children = [Coordinator]()

    init?(root: SidebarViewController, services: Services, syncManager: SyncManager, networkManager: NetworkManager, permissionsManager: PermissionsManager) {
        guard let viewModel = SettingsMenuViewModel(services: services) else { return nil }
        self.rootViewController = root
        self.services = services
        self.networkManager = networkManager
        self.syncManager = syncManager
        self.permissionsManager = permissionsManager
        settingsMenuViewController = SettingsMenuViewController(viewModel: viewModel)
        settingsMenuViewController.title = R.string.localized.settingsTitle().uppercased()
        settingsMenuViewController.delegate = self
    }

    func start() {
        rootViewController.pushToStart(childViewController: settingsMenuViewController)
    }
}

// MARK: - SettingsMenuViewControllerDelegate

extension SettingsMenuCoordinator: SettingsMenuViewControllerDelegate {

    func didTapGeneral(in viewController: SettingsMenuViewController) {
        startSettingsCoordinator(settingsType: .general, root: viewController)
    }

    func didTapSecurity(in viewController: SettingsMenuViewController) {
        startSettingsCoordinator(settingsType: .security, root: viewController)
    }

    func didTapNotifications(in viewController: SettingsMenuViewController) {
        startSettingsCoordinator(settingsType: .notifications, root: viewController)
    }

    func didTapLogout(in viewController: SettingsMenuViewController) {
        NotificationHandler.postNotification(withName: .logoutNotification)
    }

    private func startSettingsCoordinator(settingsType: SettingsType.SectionType, root: SettingsMenuViewController) {
        guard let coordinator = SettingsCoordinator(root: root,
                                                    services: services,
                                                    settingsType: settingsType,
                                                    syncManager: syncManager,
                                                    networkManager: networkManager,
                                                    permissionsManager: permissionsManager) else { return }
        startChild(child: coordinator)
    }
}
