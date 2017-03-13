//
//  MainMenuCoordinator.swift
//  QOT
//
//  Created by Sam Wyndham on 13/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class MainMenuCoordinator: ParentCoordinator {
    fileprivate let rootVC: UIViewController
    fileprivate let databaseManager: DatabaseManager
    
    var children: [Coordinator] = []
    
    init(root: UIViewController, databaseManager: DatabaseManager) {
        self.rootVC = root
        self.databaseManager = databaseManager
    }
    
    func start() {
        let vc = MainMenuViewController()
        vc.delegate = self
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .custom
        rootVC.present(vc, animated: true)
    }
}

extension MainMenuCoordinator: MainMenuViewControllerDelegate {
    func didTapLearn(in viewController: MainMenuViewController) {
        let coordinator = LearnCategoryListCoordinator(root: viewController, databaseManager: databaseManager)
        coordinator.start()
        children.append(coordinator)
    }
    
    func didTapMe(in viewController: MainMenuViewController) {
        print("Did tap Me")
    }
    
    func didTapPrepare(in viewController: MainMenuViewController) {
        print("Did tap prepare")
    }
}
