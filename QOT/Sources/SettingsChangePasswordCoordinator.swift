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

    fileprivate let services: Services
    fileprivate let rootViewController: UIViewController
    var children = [Coordinator]()

    init(root: SettingsViewController, services: Services) {
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
