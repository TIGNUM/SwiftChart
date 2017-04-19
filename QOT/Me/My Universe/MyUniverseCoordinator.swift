//
//  MyUniverseCoordinator.swift
//  QOT
//
//  Created by karmic on 22/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

final class MyUniverseCoordinator: ParentCoordinator {
    
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

    }

    func startWeeklyChoices() {
        let weeklyChoicesViewController = WeeklyChoicesViewController(viewModel: WeeklyChoicesViewModel())
        weeklyChoicesViewController.delegate = self
        rootViewController.present(weeklyChoicesViewController, animated: true)
    }

    func startMyToBeVisiom() {
        let myToBeVisionViewController = MyToBeVisionViewController(viewModel: MyToBeVisionViewModel())
        myToBeVisionViewController.delegate = self
        rootViewController.present(myToBeVisionViewController, animated: true)
    }
}

// MARK: - WeeklyChoicesViewControllerDelegate

extension MyUniverseCoordinator: WeeklyChoicesViewControllerDelegate {

    func didTapClose(in viewController: UIViewController, animated: Bool) {
        viewController.dismiss(animated: true, completion: nil)
    }

    func didTapShare(in viewController: UIViewController, from rect: CGRect, with item: WeeklyChoice) {
        log("didTapShare in: \(viewController), from rect: \(rect ) with item: \(item)")
    }
}

// MARK: - MyToBeVisionViewControllerDelegate

extension MyUniverseCoordinator: MyToBeVisionViewControllerDelegate {

    func didTapClose(in viewController: MyToBeVisionViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}
