//
//  SidebarItemCoordinator.swift
//  QOT
//
//  Created by karmic on 28.04.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

final class SidebarItemCoordinator: ParentCoordinator {

    fileprivate let rootViewController: SidebarViewController
    fileprivate let services: Services
    fileprivate let eventTracker: EventTracker
    fileprivate let contentCollections: [ContentCollection]
    var children = [Coordinator]()
    lazy var presentationManager = PresentationManager()

    init(
        root: SidebarViewController,
        services: Services,
        eventTracker: EventTracker,
        contentCollections: [ContentCollection]) {
            self.rootViewController = root
            self.services = services
            self.eventTracker = eventTracker
            self.contentCollections = contentCollections
    }

    func start() {
        let viewModel = SidebarItemViewModel(contentCollections: contentCollections)
        let sidebarItemViewController = SidebarItemViewController(viewModel: viewModel)

        let topTabBarControllerItem = TopTabBarController.Item(
            controllers: [sidebarItemViewController],
            themes: [.dark],
            titles: [R.string.localized.sidebarTitleBenefits()]
        )

        let topTabBarController = TopTabBarController(
            item: topTabBarControllerItem,
            leftIcon: R.image.ic_minimize(),
            rightIcon: R.image.ic_share()
        )

        presentationManager.presentationType = .fadeIn
        topTabBarController.modalPresentationStyle = .custom
        topTabBarController.transitioningDelegate = presentationManager
        topTabBarController.delegate = self
        rootViewController.present(topTabBarController, animated: true)
        // TODO: Update associatedEntity with realm object when its created.
        eventTracker.track(page: sidebarItemViewController.pageID, referer: rootViewController.pageID, associatedEntity: nil)
    }
}

// MARK: - TopTabBarDelegate

extension SidebarItemCoordinator: TopTabBarDelegate {

    func didSelectLeftButton(sender: TopTabBarController) {
        sender.dismiss(animated: true, completion: nil)
        removeChild(child: self)
    }

    func didSelectRightButton(sender: TopTabBarController) {
        print("didSelectRightButton")
    }

    func didSelectItemAtIndex(index: Int, sender: TopTabBarController) {
        print("didSelectItemAtIndex")
    }
}
