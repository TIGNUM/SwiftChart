//
//  SettingsChangePasswordCoordinator.swift
//  QOT
//
//  Created by karmic on 01.08.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

final class SettingsChangePasswordCoordinator: ParentCoordinator {

    private let services: Services
    private let rootViewController: UIViewController
    var children = [Coordinator]()

    init(root: OldSettingsViewController, services: Services) {
        self.rootViewController = root
        self.services = services
    }

    func start() {
        let storyboard = R.storyboard.settingsChangePasswordViewController()

        guard let settingsChangePasswordViewController = storyboard.instantiateInitialViewController() as? SettingsChangePasswordViewController  else {
            return
        }

        rootViewController.pushToStart(childViewController: settingsChangePasswordViewController)
    }
}
