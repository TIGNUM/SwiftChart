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
        prepareContentViewController.delegate = self

        let topTabBarControllerItem = TopTabBarController.Item(
            controllers: [prepareContentViewController],
            titles: [R.string.localized.topTabBarItemTitlePerpareCoach()]
        )

        let topTabBarController = TopTabBarController(
            item: topTabBarControllerItem,            
            leftIcon: R.image.ic_minimize(),
            rightIcon: R.image.ic_save()
        )

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

    func didTapVideo(with ID: String, from view: UIView, in viewController: PrepareContentViewController) {
        log("didTapVideo: ID: \(ID)")
    }

    func didTapSaveAs(sectionID: String, in viewController: PrepareContentViewController) {
        let viewModel = MyPrepViewModel()
        let vc = MyPrepViewController(viewModel: viewModel)
        viewController.present(vc, animated: true)
    }

    func didTapAddToNotes(sectionID: String, in viewController: PrepareContentViewController) {
        log("didTapAddToNotes")
    }

    func didTapAddPreparation(sectionID: String, in viewController: PrepareContentViewController) {
        let viewModel = PrepareEventsViewModel()
        let vc = PrepareEventsViewController(viewModel: viewModel)
        viewController.present(vc, animated: true)
    }

    func didTapSaveAs(in viewController: PrepareContentViewController) {
        let viewModel = MyPrepViewModel()
        let vc = MyPrepViewController(viewModel: viewModel)
        viewController.present(vc, animated: true)
    }

    func didTapAddToNotes(in viewController: PrepareContentViewController) {
        log("didTapAddToNotes")
    }

    func didTapAddPreparation(in viewController: PrepareContentViewController) {
        let viewModel = PrepareEventsViewModel()
        let vc = PrepareEventsViewController(viewModel: viewModel)
        viewController.present(vc, animated: true)
    }
}

// MARK: - TopTabBarDelegate

extension PrepareContentCoordinator: TopTabBarDelegate {

    func didSelectRightButton(sender: TopTabBarController) {
        print("didSelect SAVE Item")
    }

    func didSelectLeftButton(sender: TopTabBarController) {
        sender.dismiss(animated: true, completion: nil)
    }

    func didSelectItemAtIndex(index: Int?, sender: TopTabBarController) {
        print(index, sender)
    }
}
