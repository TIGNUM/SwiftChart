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

    fileprivate let rootViewController: SettingsViewController
    fileprivate let services: Services
    var children = [Coordinator]()

    init(root: SettingsViewController, services: Services) {
        self.rootViewController = root
        self.services = services
    }

    func start() {
        let storyboard = UIStoryboard(name: "SettingsChangePasswordViewController", bundle: nil)

        guard let navigationController = storyboard.instantiateInitialViewController() as? UINavigationController  else {
            return
        }

        rootViewController.presentRightToLeft(controller: navigationController)
//
//        let changePasswordViewController = SettingsChangePasswordViewController()
//        let navigationController = UINavigationController(rootViewController: changePasswordViewController)
//
//        rootViewController.present(navigationController, animated: true, completion: nil)
    }
}
