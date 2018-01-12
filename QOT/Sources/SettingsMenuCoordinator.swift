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
    private let rootViewController: UIViewController
    private let networkManager: NetworkManager
    private let syncManager: SyncManager
    private let permissionsManager: PermissionsManager
    private var guideItem: Guide.Item?
    let settingsMenuViewController: SettingsMenuViewController
    var settingsCoordinator: SettingsCoordinator?
    var children = [Coordinator]()

    init?(root: SidebarViewController,
          services: Services,
          syncManager: SyncManager,
          networkManager: NetworkManager,
          permissionsManager: PermissionsManager,
          guideItem: Guide.Item?) {
        guard let viewModel = SettingsMenuViewModel(services: services) else { return nil }
        self.rootViewController = root
        self.services = services
        self.networkManager = networkManager
        self.syncManager = syncManager
        self.permissionsManager = permissionsManager
        self.guideItem = guideItem
        settingsMenuViewController = SettingsMenuViewController(viewModel: viewModel, guideItem: guideItem)
        settingsMenuViewController.title = R.string.localized.settingsTitle().uppercased()
        settingsMenuViewController.delegate = self
    }

    func start() {
        rootViewController.pushToStart(childViewController: settingsMenuViewController)
    }
}

// MARK: - SettingsMenuViewControllerDelegate

extension SettingsMenuCoordinator: SettingsMenuViewControllerDelegate {

    func goToGeneralSettings(from viewController: SettingsMenuViewController, guideItem: Guide.Item?) {
        startSettingsCoordinator(settingsType: .general, root: settingsMenuViewController, guideItem: guideItem)
    }

    func didTapGeneral(in viewController: SettingsMenuViewController) {
        startSettingsCoordinator(settingsType: .general, root: viewController, guideItem: nil)
    }

    func didTapSecurity(in viewController: SettingsMenuViewController) {
        startSettingsCoordinator(settingsType: .security, root: viewController, guideItem: nil)
    }

    func didTapNotifications(in viewController: SettingsMenuViewController) {
        startSettingsCoordinator(settingsType: .notifications, root: viewController, guideItem: nil)
    }

    func didTapLogout(in viewController: SettingsMenuViewController) {
        NotificationHandler.postNotification(withName: .logoutNotification)
    }

    private func startSettingsCoordinator(settingsType: SettingsType.SectionType,
                                          root: SettingsMenuViewController,
                                          guideItem: Guide.Item?) {
        guard let coordinator = SettingsCoordinator(root: root,
                                                    services: services,
                                                    settingsType: settingsType,
                                                    syncManager: syncManager,
                                                    networkManager: networkManager,
                                                    permissionsManager: permissionsManager,
                                                    guideItem: guideItem) else { return }
        settingsCoordinator = coordinator
        startChild(child: coordinator)
    }
}
