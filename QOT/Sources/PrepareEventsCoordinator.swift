//
//  PrepareEventsCoordinator.swift
//  QOT
//
//  Created by karmic on 03.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

final class PrepareEventsCoordinator: ParentCoordinator {

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
        let viewModel = PrepareEventsViewModel()
        let prepareEventsViewController = PrepareEventsViewController(viewModel: viewModel)

        let topTabBarControllerItem = TopTabBarController.Item(
            controllers: [prepareEventsViewController],
            titles: [R.string.localized.preparePrepareEventsAddPreparation()]
        )

        let topTabBarController = TopTabBarController(
            item: topTabBarControllerItem,
            rightIcon: R.image.ic_close()
        )

        topTabBarController.delegate = self
        prepareEventsViewController.delegate = self
        rootViewController.present(topTabBarController, animated: true)
    }
}

// MARK: - PrepareEventsViewControllerDelegate

extension PrepareEventsCoordinator: PrepareEventsViewControllerDelegate {

    func didTapItem(item: PrepareEventsItem, in viewController: PrepareEventsViewController) {
        print("didTapItem", item)
    }
}

// MARK: - TopTabBarDelegate

extension PrepareEventsCoordinator: TopTabBarDelegate {

    func didSelectLeftButton(sender: TopTabBarController) {
        print("didSelectLeftButton")
    }

    func didSelectRightButton(sender: TopTabBarController) {
        print("didSelectRightButton")
        sender.dismiss(animated: true, completion: nil)
    }

    func didSelectItemAtIndex(index: Int?, sender: TopTabBarController) {
        print("didSelectItemAtIndex")
    }
}
