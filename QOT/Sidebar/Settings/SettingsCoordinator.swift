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
    lazy var presentationManager = PresentationManager()
    
    init(root: SettingsMenuViewController, services: Services, eventTracker: EventTracker, settingsType: SettingsViewModel.SettingsType) {
        self.rootViewController = root
        self.services = services
        self.eventTracker = eventTracker
        self.settingsType = settingsType
    }

    func start() {
        let settingsViewController = SettingsViewController(viewModel: SettingsViewModel(settingsType: settingsType))
        presentationManager.presentationType = .fadeIn
        settingsViewController.modalPresentationStyle = .custom
        settingsViewController.transitioningDelegate = presentationManager

        let topTabBarController = TopTabBarController(
            items: [settingsViewController.topTabBarItem],
            selectedIndex: 0,
            leftIcon: R.image.ic_minimize()
        )

        topTabBarController.delegate = self
        rootViewController.show(topTabBarController, sender: nil)
    }
}

// MARK: - TopTabBarDelegate

extension SettingsCoordinator: TopTabBarDelegate {

    func didSelectLeftButton(sender: TopTabBarController) {
        sender.dismiss(animated: true, completion: nil)
        removeChild(child: self)
    }

    func didSelectRightButton(sender: TopTabBarController) {
        print("didSelectRightButton")
    }

    func didSelectItemAtIndex(index: Int?, sender: TopTabBarController) {
        print("didSelectItemAtIndex", index, sender)
    }
}
