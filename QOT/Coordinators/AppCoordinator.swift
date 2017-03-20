//
//  AppCoordinator.swift
//  QOT
//
//  Created by Sam Wyndham on 08/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import RealmSwift

final class AppCoordinator: ParentCoordinator {
    fileprivate let window: UIWindow
    fileprivate var databaseManager: DatabaseManager?
    fileprivate lazy var eventTracker: EventTracker = {
        return EventTracker(realmProvider: { return try Realm() })
    }()
    fileprivate lazy var launchVC: LaunchViewController = {
        let vc = LaunchViewController(viewModel: LaunchViewModel())
        vc.delegate = self
        return vc
    }()
    
    var children: [Coordinator] = []

    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        window.rootViewController = launchVC
        window.makeKeyAndVisible()
        
        DatabaseManager.make { (result) in
            switch result {
            case .success(let manager):
                self.databaseManager = manager
                self.launchVC.viewModel.ready.value = true
                
                self.eventTracker.track(page: self.launchVC.pageID, referer: nil, associatedEntity: nil)
            case .failure(_):
                // FIXME: Alert user that the app cannot be run
                break
            }
        }
    }
}

extension AppCoordinator: LaunchViewControllerDelegate {
    func didTapLaunchViewController(_ viewController: LaunchViewController) {
        guard let databaseManager = databaseManager else {
            preconditionFailure("databaseManager & tracker must exist")
        }
        
        let coordinator = MainMenuCoordinator(root: viewController, databaseManager: databaseManager, eventTracker: eventTracker)
        coordinator.start()
        children.append(coordinator)
    }
    
    func didTapSettingsButton(in viewController: LaunchViewController) {
        guard let databaseManager = databaseManager else {
            preconditionFailure("databaseManager & tracker must exist")
        }
        
        let coordinator = SettingsCoordinator(root: viewController, databaseManager: databaseManager, eventTracker: self.eventTracker)
        coordinator.start()
        children.append(coordinator)
    }
}
