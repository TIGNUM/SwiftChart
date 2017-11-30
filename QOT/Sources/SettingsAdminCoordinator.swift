//
//  SettingsAdminCoordinator.swift
//  QOT
//
//  Created by karmic on 30.10.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

final class SettingsAdminCoordinator: ParentCoordinator {

    private let services: Services
    private let rootViewController: UIViewController
    private let syncManager: SyncManager
    private let networkManager: NetworkManager
    var children = [Coordinator]()

    init(root: SettingsViewController, services: Services, syncManager: SyncManager, networkManager: NetworkManager) {
        self.rootViewController = root
        self.services = services
        self.networkManager = networkManager
        self.syncManager = syncManager
    }

    func start() {
        let storyboard = R.storyboard.settingsAdmin()

        guard let settingsAdminViewController = storyboard.instantiateInitialViewController() as? SettingsAdminViewController  else {
            return
        }

        settingsAdminViewController.syncManager = syncManager
        settingsAdminViewController.services = services
        settingsAdminViewController.networkManager = networkManager
        rootViewController.pushToStart(childViewController: settingsAdminViewController)
    }
}
