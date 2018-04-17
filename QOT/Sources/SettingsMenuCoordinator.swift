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
    private var destination: AppCoordinator.Router.Destination?
    let settingsMenuViewController: SettingsMenuViewController
    var settingsCoordinator: SettingsCoordinator?
    var children = [Coordinator]()

    init?(root: SidebarViewController,
          services: Services,
          syncManager: SyncManager,
          networkManager: NetworkManager,
          permissionsManager: PermissionsManager,
          destination: AppCoordinator.Router.Destination?) {
        guard let viewModel = SettingsMenuViewModel(services: services) else { return nil }
        self.rootViewController = root
        self.services = services
        self.networkManager = networkManager
        self.syncManager = syncManager
        self.permissionsManager = permissionsManager
        self.destination = destination
        settingsMenuViewController = SettingsMenuViewController(viewModel: viewModel, destination: destination, permissionsManager: permissionsManager)
        settingsMenuViewController.title = R.string.localized.settingsTitle().uppercased()
        settingsMenuViewController.delegate = self
    }

    func start() {
        rootViewController.pushToStart(childViewController: settingsMenuViewController)
    }
}

// MARK: - SettingsMenuViewControllerDelegate

extension SettingsMenuCoordinator: SettingsMenuViewControllerDelegate {

    func goToNotificationsSettings(from viewController: SettingsMenuViewController,
                                   destination: AppCoordinator.Router.Destination) {
        didTapNotifications(in: viewController)
    }

    func goToGeneralSettings(from viewController: SettingsMenuViewController,
                             destination: AppCoordinator.Router.Destination) {
        startSettingsCoordinator(settingsType: .general, root: settingsMenuViewController, destination: destination)
    }

    func didTapGeneral(in viewController: SettingsMenuViewController) {
        startSettingsCoordinator(settingsType: .general, root: viewController, destination: nil)
    }

    func didTapSecurity(in viewController: SettingsMenuViewController) {
        startSettingsCoordinator(settingsType: .security, root: viewController, destination: nil)
    }

    func didTapNotifications(in viewController: SettingsMenuViewController) {
        startSettingsCoordinator(settingsType: .notifications, root: viewController, destination: nil)
    }

    // MARK: - Private

    private func startSettingsCoordinator(settingsType: SettingsType.SectionType,
                                          root: SettingsMenuViewController,
                                          destination: AppCoordinator.Router.Destination?) {
        guard let coordinator = SettingsCoordinator(root: root,
                                                    services: services,
                                                    settingsType: settingsType,
                                                    syncManager: syncManager,
                                                    networkManager: networkManager,
                                                    permissionsManager: permissionsManager,
                                                    destination: destination) else { return }
        settingsCoordinator = coordinator
        startChild(child: coordinator)
    }
}
