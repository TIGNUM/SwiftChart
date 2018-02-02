//
//  SettingsCoordinator.swift
//  QOT
//
//  Created by karmic on 20/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

protocol SettingsCoordinatorDelegate: class {

    func goToCalendarListViewController(settingsViewController: SettingsViewController,
                                        destination: AppCoordinator.Router.Destination?)

    func openCalendarListViewController(settingsViewController: SettingsViewController)

    func openChangePasswordViewController(settingsViewController: SettingsViewController)

    func openArticleViewController(viewController: SettingsViewController, settingsType: SettingsType)

    func openAdminSettingsViewController(settingsViewController: SettingsViewController)
}

final class SettingsCoordinator: ParentCoordinator {

    private let services: Services
    private let permissionsManager: PermissionsManager
    private let rootViewController: UIViewController
    private let networkManager: NetworkManager
    private let syncManager: SyncManager
    private let destination: AppCoordinator.Router.Destination?
    var children = [Coordinator]()
    let settingsType: SettingsType.SectionType
    let settingsViewController: SettingsViewController

    init?(root: SettingsMenuViewController,
          services: Services,
          settingsType: SettingsType.SectionType,
          syncManager: SyncManager,
          networkManager: NetworkManager,
          permissionsManager: PermissionsManager,
          destination: AppCoordinator.Router.Destination?) {
        guard let viewModel = SettingsViewModel(services: services, settingsType: settingsType) else { return nil }
        self.rootViewController = root
        self.services = services
        self.settingsType = settingsType
        self.networkManager = networkManager
        self.syncManager = syncManager
        self.permissionsManager = permissionsManager
        self.destination = destination
        settingsViewController = SettingsViewController(viewModel: viewModel,
                                                        services: services,
                                                        settingsType: settingsType,
                                                        destination: destination)
        settingsViewController.title = settingsType.title.uppercased()
        settingsViewController.delegate = self
    }

    func start() {
        rootViewController.pushToStart(childViewController: settingsViewController)
    }
}

// MARK: - SettingsCoordinatorDelegate

extension SettingsCoordinator: SettingsCoordinatorDelegate {

    func goToCalendarListViewController(settingsViewController: SettingsViewController,
                                        destination: AppCoordinator.Router.Destination?) {
        openCalendarListViewController(settingsViewController: settingsViewController)
    }

    func openCalendarListViewController(settingsViewController: SettingsViewController) {
        permissionsManager.askPermission(for: [.calendar], completion: { [unowned self] status in
            guard let status = status[.calendar] else { return }

            switch status {
            case .granted:
                let coordinator = SettingsCalendarListCoordinator(root: settingsViewController, services: self.services)
                self.startChild(child: coordinator)
            case .denied:
                settingsViewController.showAlert(type: .settingsCalendars, handler: {
                    UIApplication.openAppSettings()
                }, handlerDestructive: nil)
            case .later:
                self.permissionsManager.updateAskStatus(.canAsk, for: .calendar)
                self.openCalendarListViewController(settingsViewController: settingsViewController)
            }
        })
    }

    func openChangePasswordViewController(settingsViewController: SettingsViewController) {
        let coordinator = ResetPasswordCoordinator(rootVC: settingsViewController, parentCoordinator: self, networkManager: networkManager)
        startChild(child: coordinator)
    }

    func openArticleViewController(viewController: SettingsViewController, settingsType: SettingsType) {
        let contentCollection = settingsType.contentCollection(service: services.contentService)
        guard let coordinator = ArticleContentItemCoordinator(
            pageName: .settings, // FIXME: fix
            root: viewController,
            services: services,
            contentCollection: contentCollection,
            topTabBarTitle: contentCollection?.title.uppercased(), backgroundImage: nil) else {
                return
        }

        startChild(child: coordinator)
    }

    func openAdminSettingsViewController(settingsViewController: SettingsViewController) {
        let coordinator = SettingsAdminCoordinator(root: settingsViewController, services: services, syncManager: syncManager, networkManager: networkManager)
        startChild(child: coordinator)
    }
}
