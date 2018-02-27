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
    private var myToBeVisionViewController: MyToBeVisionViewController!
    private let rootViewController: UIViewController
    private let transitioningDelegate: UIViewControllerTransitioningDelegate // swiftlint:disable:this weak_delegate
    var children: [Coordinator] = []

    // MARK: - Life Cycle

    init(root: UIViewController, transitioningDelegate: UIViewControllerTransitioningDelegate, services: Services) {
        self.rootViewController = root
        self.transitioningDelegate = transitioningDelegate
        self.services = services

        let configurator = MyToBeVisionConfigurator.make()
        myToBeVisionViewController = MyToBeVisionViewController(configurator: configurator)
        myToBeVisionViewController.modalPresentationStyle = .custom

        super.init()
        myToBeVisionViewController.transitioningDelegate = transitioningDelegate
    }

    func start() {
        rootViewController.present(myToBeVisionViewController, animated: true)
    }
}
