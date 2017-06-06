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

    fileprivate let rootViewController: UIViewController
    fileprivate let services: Services
    fileprivate let eventTracker: EventTracker

    var children: [Coordinator] = []

    // MARK: - Life Cycle

    init(root: UIViewController, services: Services, eventTracker: EventTracker) {
        self.rootViewController = root
        self.services = services
        self.eventTracker = eventTracker
    }

    func start() {
        let weeklyChoicesViewController = WeeklyChoicesViewController(viewModel: WeeklyChoicesViewModel())
        weeklyChoicesViewController.delegate = self

        let topTabBarControllerItem = TopTabBarController.Item(
            controllers: [weeklyChoicesViewController],
            themes: [.darkClear],
            titles: [R.string.localized.meSectorMyWhyWeeklyChoicesTitle()]
        )

        let topTabBarController = TopTabBarController(
            item: topTabBarControllerItem,            
            leftIcon: R.image.ic_minimize()
        )
        
        topTabBarController.delegate = self
        rootViewController.present(topTabBarController, animated: true)
    }
}

// MARK: - WeeklyChoicesViewControllerDelegate

extension WeeklyChoicesCoordinator: WeeklyChoicesViewControllerDelegate {

    func didTapClose(in viewController: UIViewController, animated: Bool) {
        viewController.dismiss(animated: true, completion: nil)
        removeChild(child: self)
    }

    func didTapShare(in viewController: UIViewController, from rect: CGRect, with item: WeeklyChoice) {
        log("didTapShare in: \(viewController), from rect: \(rect ) with item: \(item)")
    }
}

extension WeeklyChoicesCoordinator: TopTabBarDelegate {

    func didSelectItemAtIndex(index: Int?, sender: TopTabBarController) {
        print(index as Any, sender)
    }

    func didSelectLeftButton(sender: TopTabBarController) {
        sender.dismiss(animated: true, completion: nil)
    }

    func didSelectRightButton(sender: TopTabBarController) {
        print(sender)
    }

}
