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
    
    var children: [Coordinator] = []

    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        window.rootViewController = rootVC
        window.makeKeyAndVisible()
        
        let coordinator = LearnCategoryListCoordinator(root: rootVC)
        coordinator.start()
        children.append(coordinator)
    }
}
