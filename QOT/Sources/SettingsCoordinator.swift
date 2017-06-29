//
//  SettingsCoordinator.swift
//  QOT
//
//  Created by karmic on 20/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

final class SettingsCoordinator: ParentCoordinator {
    
    fileprivate let rootViewController: SettingsMenuViewController
    fileprivate let services: Services
    fileprivate let eventTracker: EventTracker
    fileprivate let settingsType: SettingsViewModel.SettingsType
    var children = [Coordinator]()

    init(root: SettingsMenuViewController, services: Services, eventTracker: EventTracker, settingsType: SettingsViewModel.SettingsType) {
        self.rootViewController = root
        self.services = services
        self.eventTracker = eventTracker
        self.settingsType = settingsType
    }

    func start() {
        let settingsViewController = SettingsViewController(viewModel: SettingsViewModel(settingsType: settingsType))
        let topTabBarControllerItem = TopTabBarController.Item(
            controllers: [settingsViewController],
            themes: [.dark],
            titles: [settingsType.title]
        )

        let topTabBarController = TopTabBarController(
            item: topTabBarControllerItem,            
            leftIcon: R.image.ic_back()
        )

        topTabBarController.delegate = self
        rootViewController.presentRightToLeft(controller: topTabBarController)
    }
}

// MARK: - TopTabBarDelegate

extension SettingsCoordinator: TopTabBarDelegate {

    func didSelectLeftButton(sender: TopTabBarController) {
        sender.dismissLeftToRight()
        removeChild(child: self)
    }

    func didSelectRightButton(sender: TopTabBarController) {
        print("didSelectRightButton")
    }

    func didSelectItemAtIndex(index: Int, sender: TopTabBarController) {
        print("didSelectItemAtIndex", index as Any, sender)
    }
}
