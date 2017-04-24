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
    
    fileprivate let rootViewController: SidebarViewController
    fileprivate let services: Services?
    fileprivate let eventTracker: EventTracker?
    internal var children = [Coordinator]()
    lazy var presentationManager = PresentationManager()
    
    init(root: SidebarViewController, services: Services?, eventTracker: EventTracker?) {
        self.rootViewController = root
        self.services = services
        self.eventTracker = eventTracker
    }

    func start() {
        let settingsMenuViewController = SettingsMenuViewController(viewModel: SettingsMenuViewModel())
        presentationManager.presentationType = .fadeIn
        settingsMenuViewController.modalPresentationStyle = .custom
        settingsMenuViewController.transitioningDelegate = presentationManager

        let topTabBarController = TopTabBarController(
            items: [settingsMenuViewController.topTabBarItem],
            selectedIndex: 0,
            leftIcon: R.image.ic_minimize()
        )

        topTabBarController.delegate = self
        rootViewController.present(topTabBarController, animated: true)
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
