//
//  PrepareContentCoordinator.swift
//  QOT
//
//  Created by karmic on 24.04.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

final class PrepareContentCoordinator: ParentCoordinator {

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
        let viewModel = PrepareContentViewModel()
        let prepareContentViewController = PrepareContentViewController(viewModel: viewModel)

        let topTabBarControllerItem = TopTabBarController.Item(
            controllers: [prepareContentViewController],
            themes: [.light],
            titles: [R.string.localized.topTabBarItemTitlePerpareCoach()]
        )

        let topTabBarController = TopTabBarController(
            item: topTabBarControllerItem,            
            leftIcon: R.image.ic_minimize(),
            rightIcon: R.image.ic_save()
        )

        prepareContentViewController.delegate = self
        topTabBarController.delegate = self
        rootViewController.present(topTabBarController, animated: true)
    }
}

// MARK: - PrepareContentViewControllerDelegate

extension PrepareContentCoordinator: PrepareContentViewControllerDelegate {

    func didTapClose(in viewController: PrepareContentViewController) {
        viewController.dismiss(animated: true, completion: nil)
        removeChild(child: self)
    }

    func didTapShare(in viewController: PrepareContentViewController) {
        log("didTapShare")
    }

    func didTapVideo(with videoURL: URL, from view: UIView, in viewController: PrepareContentViewController) {
        log("didTapVideo: :")
    }

    func didTapReadMore(readMoreID: Int, in viewController: PrepareContentViewController) {
        log("didTapReadMore: ID: \(readMoreID)")
//        startPrepareEventsCoordinator(viewController: viewController)
    }

    private func startPrepareEventsCoordinator(viewController: UIViewController) {
        let coordinator = PrepareEventsCoordinator(root: viewController, services: services, eventTracker: eventTracker)
        startChild(child: coordinator)
    }
}

// MARK: - TopTabBarDelegate

extension PrepareContentCoordinator: TopTabBarDelegate {

    func didSelectRightButton(sender: TopTabBarController) {
        print("didSelectRightButton")
    }

    func didSelectLeftButton(sender: TopTabBarController) {
        sender.dismiss(animated: true, completion: nil)
    }

    func didSelectItemAtIndex(index: Int, sender: TopTabBarController) {
        print(index as Any, sender)
    }
}
