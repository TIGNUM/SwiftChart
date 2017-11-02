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

    func openCalendarListViewController(settingsViewController: SettingsViewController)

    func openChangePasswordViewController(settingsViewController: SettingsViewController)

    func openArticleViewController(viewController: SettingsViewController, settingsType: SettingsType)
    
    func openAdminSettingsViewController(settingsViewController: SettingsViewController)
}

final class SettingsCoordinator: ParentCoordinator {

    private let services: Services
    private let settingsViewController: SettingsViewController
    private let permissionHandler = PermissionHandler()
    private var calandarAccessGaranted = true
    private let rootViewController: UIViewController
    private let networkManager: NetworkManager
    private let syncManager: SyncManager
    var children = [Coordinator]()
    let settingsType: SettingsType.SectionType

    init?(root: SettingsMenuViewController, services: Services, settingsType: SettingsType.SectionType, syncManager: SyncManager, networkManager: NetworkManager) {
        guard let viewModel = SettingsViewModel(services: services, settingsType: settingsType) else { return nil }
        self.rootViewController = root
        self.services = services
        self.settingsType = settingsType
        self.networkManager = networkManager
        self.syncManager = syncManager
        settingsViewController = SettingsViewController(viewModel: viewModel, services: services, settingsType: settingsType)
        settingsViewController.title = settingsType.title.uppercased()
        settingsViewController.delegate = self
        askPermissionForCalendar()
    }

    private func askPermissionForCalendar() {
        PermissionHandler().askPermissionForCalendar { (garanted: Bool) in
            self.calandarAccessGaranted = garanted
        }
    }

    func start() {
        rootViewController.pushToStart(childViewController: settingsViewController)
    }
}

// MARK: - SettingsCoordinatorDelegate

extension SettingsCoordinator: SettingsCoordinatorDelegate {

    func openCalendarListViewController(settingsViewController: SettingsViewController) {
        switch calandarAccessGaranted {
        case true:
            let coordinator = SettingsCalendarListCoordinator(root: settingsViewController, services: self.services)
            self.startChild(child: coordinator)
        case false:
            settingsViewController.showAlert(type: .settingsCalendars, handler: {
                UIApplication.openAppSettings()
            }, handlerDestructive: nil)
        }
    }

    func openChangePasswordViewController(settingsViewController: SettingsViewController) {
        let coordinator = ResetPasswordCoordinator(rootVC: settingsViewController, parentCoordinator: self, networkManager: NetworkManager())
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
