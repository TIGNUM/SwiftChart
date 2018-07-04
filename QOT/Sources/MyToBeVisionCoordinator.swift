//
//  MyToBeVisionCoordinator.swift
//  QOT
//
//  Created by karmic on 19.04.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

final class MyToBeVisionCoordinator: NSObject, ParentCoordinator {

    // MARK: - Properties

    private let services: Services
    private let rootViewController: UIViewController
    private let transitioningDelegate: UIViewControllerTransitioningDelegate? // swiftlint:disable:this weak_delegate
    var children: [Coordinator] = []

    // MARK: - Life Cycle

    init(root: UIViewController, transitioningDelegate: UIViewControllerTransitioningDelegate?, services: Services) {
        self.rootViewController = root
        self.transitioningDelegate = transitioningDelegate
        self.services = services
        super.init()
    }

    func start() {
        let configurator = MyToBeVisionConfigurator.make()
        let myToBeVisionViewController = MyToBeVisionViewController(configurator: configurator)
        let navController = UINavigationController(rootViewController: myToBeVisionViewController)

        navController.navigationBar.applyDefaultStyle()
        navController.modalPresentationStyle = .custom
        navController.transitioningDelegate = transitioningDelegate
        rootViewController.present(navController, animated: true)
    }
}
