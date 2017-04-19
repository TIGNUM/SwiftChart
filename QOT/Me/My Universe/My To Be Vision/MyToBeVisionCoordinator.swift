//
//  MyToBeVisionCoordinator.swift
//  QOT
//
//  Created by karmic on 19.04.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

final class MyToBeVisionCoordinator: ParentCoordinator {

    // MARK: - Properties

    fileprivate let rootViewController: MyUniverseViewController
    fileprivate let services: Services
    fileprivate let eventTracker: EventTracker

    var children: [Coordinator] = []

    // MARK: - Life Cycle

    init(root: MyUniverseViewController, services: Services, eventTracker: EventTracker) {
        self.rootViewController = root
        self.services = services
        self.eventTracker = eventTracker
    }

    func start() {
        let myToBeVisionViewController = MyToBeVisionViewController(viewModel: MyToBeVisionViewModel())
        myToBeVisionViewController.delegate = self
        rootViewController.present(myToBeVisionViewController, animated: true)
    }
}

// MARK: - MyToBeVisionViewControllerDelegate

extension MyToBeVisionCoordinator: MyToBeVisionViewControllerDelegate {

    func didTapClose(in viewController: MyToBeVisionViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}

