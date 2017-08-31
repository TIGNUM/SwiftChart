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

    fileprivate let services: Services
    fileprivate let settingsMenuViewController: SettingsMenuViewController
    fileprivate let rootViewController: UIViewController
    var children = [Coordinator]()

    init?(root: SidebarViewController, services: Services) {
        guard let viewModel = SettingsMenuViewModel(services: services) else {
            return nil
        }
        
        self.rootViewController = root
        self.services = services
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

    private func startSettingsCoordinator(settingsType: SettingsType.SectionType, root: SettingsMenuViewController) {
        guard let coordinator = SettingsCoordinator(root: root, services: services, settingsType: settingsType) else {
            return
        }

        startChild(child: coordinator)
    }
}
