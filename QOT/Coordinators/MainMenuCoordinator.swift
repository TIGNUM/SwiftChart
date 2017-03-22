//
//  MainMenuCoordinator.swift
//  QOT
//
//  Created by Sam Wyndham on 13/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

enum MainMenuType: Int {
    case learn = 0
    case me
    case prepare
}

final class MainMenuCoordinator: ParentCoordinator {
    fileprivate let rootVC: LaunchViewController
    fileprivate let databaseManager: DatabaseManager
    fileprivate let eventTracker: EventTracker
    
    var children: [Coordinator] = []
    
    init(root: LaunchViewController, databaseManager: DatabaseManager, eventTracker: EventTracker) {
        self.rootVC = root
        self.databaseManager = databaseManager
        self.eventTracker = eventTracker
    }
    
    func start() {
        let mainMenuViewController = MainMenuViewController()
        mainMenuViewController.delegate = self
        mainMenuViewController.modalTransitionStyle = .crossDissolve
        mainMenuViewController.modalPresentationStyle = .custom
        rootVC.present(mainMenuViewController, animated: true)
        eventTracker.track(page: mainMenuViewController.pageID, referer: rootVC.pageID, associatedEntity: nil)
    }
}

extension MainMenuCoordinator: MainMenuViewControllerDelegate {
    func didTapLearn(in viewController: MainMenuViewController) {
        showTabBarController(in: viewController, with: MainMenuType.learn.rawValue)
    }
    
    func didTapMe(in viewController: MainMenuViewController) {
        showTabBarController(in: viewController, with: MainMenuType.me.rawValue)
    }
    
    func didTapPrepare(in viewController: MainMenuViewController) {
        showTabBarController(in: viewController, with: MainMenuType.prepare.rawValue)
    }
    
    func didTapSidebarButton(in viewController: MainMenuViewController) {
        let coordinator = SidebarCoordinator(root: viewController, databaseManager: databaseManager, eventTracker: eventTracker)
        startChild(child: coordinator)
    }
    
    private func showTabBarController(in viewController: MainMenuViewController, with selectedIndex: Index) {
        let tabBarCoordinator = TabBarCoordinator(rootViewController: viewController, selectedIndex: selectedIndex, databaseManager: databaseManager, eventTracker: eventTracker)
        startChild(child: tabBarCoordinator)
    }
}
