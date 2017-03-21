//
//  MainMenuCoordinator.swift
//  QOT
//
//  Created by Sam Wyndham on 13/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

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
        let vc = MainMenuViewController()
        vc.delegate = self
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .custom
        rootVC.present(vc, animated: true)
        
        eventTracker.track(page: vc.pageID, referer: rootVC.pageID, associatedEntity: nil)
    }
}

extension MainMenuCoordinator: MainMenuViewControllerDelegate {
    func didTapLearn(in viewController: MainMenuViewController) {
        let coordinator = LearnCategoryListCoordinator(root: viewController, databaseManager: databaseManager, eventTracker: eventTracker)
        coordinator.startChild(child: coordinator)
    }
    
    func didTapMe(in viewController: MainMenuViewController) {
        print("Did tap Me")
    }
    
    func didTapPrepare(in viewController: MainMenuViewController) {
        print("Did tap prepare")
    }
    
    func didTapSettingsButton(in viewController: MainMenuViewController) {
        let coordinator = SettingsCoordinator(root: viewController, databaseManager: databaseManager, eventTracker: eventTracker)
        coordinator.startChild(child: coordinator)
    }
}
