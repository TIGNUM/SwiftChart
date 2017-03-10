//
//  AppCoordinator.swift
//  QOT
//
//  Created by Sam Wyndham on 08/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class AppCoordinator: ParentCoordinator {
    private let window: UIWindow
    private lazy var rootVC: RootViewController = RootViewController()
    private lazy var databaseManager: DatabaseManager = {
        do {
            return try DatabaseManager()
        } catch let error {
            // FIXME: There are valid cases when this may fail such as if the
            // the phone has ran out of storage. In such cases we should fail 
            // gracefully and show an error.
            fatalError("Failed to open realm: \(error)")
        }
    }()
    
    var children: [Coordinator] = []

    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        window.rootViewController = rootVC
        window.makeKeyAndVisible()
        
        let coordinator = LearnCategoryListCoordinator(root: rootVC, databaseManager: databaseManager)
        coordinator.start()
        children.append(coordinator)
    }
}
