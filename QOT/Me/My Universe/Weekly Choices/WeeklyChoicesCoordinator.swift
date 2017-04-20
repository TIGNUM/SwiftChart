//
//  WeeklyChoicesCoordinator.swift
//  QOT
//
//  Created by karmic on 19.04.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

final class WeeklyChoicesCoordinator: ParentCoordinator {

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
        let weeklyChoicesViewController = WeeklyChoicesViewController(viewModel: WeeklyChoicesViewModel())
        weeklyChoicesViewController.delegate = self
        rootViewController.present(weeklyChoicesViewController, animated: true)
    }
}

// MARK: - WeeklyChoicesViewControllerDelegate

extension WeeklyChoicesCoordinator: WeeklyChoicesViewControllerDelegate {

    func didTapClose(in viewController: UIViewController, animated: Bool) {
        viewController.dismiss(animated: true, completion: nil)
    }

    func didTapShare(in viewController: UIViewController, from rect: CGRect, with item: WeeklyChoice) {
        log("didTapShare in: \(viewController), from rect: \(rect ) with item: \(item)")
    }
}
