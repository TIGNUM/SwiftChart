//
//  AppCoordinator.swift
//  QOT
//
//  Created by Sam Wyndham on 08/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class AppCoordinator: ParentCoordinator {
    fileprivate let window: UIWindow
    fileprivate var databaseManager: DatabaseManager?
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
            preconditionFailure("databaseManager must exist")
        }
        
        let coordinator = LearnCategoryListCoordinator(root: viewController, databaseManager: databaseManager)
        coordinator.start()
        children.append(coordinator)
    }
}
