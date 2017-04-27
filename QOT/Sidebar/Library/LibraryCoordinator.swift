//
//  LibraryCoordinator.swift
//  QOT
//
//  Created by karmic on 30/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

final class LibraryCoordinator: ParentCoordinator {

    // MARK: - Properties

    fileprivate let rootViewController: SidebarViewController
    fileprivate let services: Services
    fileprivate let eventTracker: EventTracker
    var children = [Coordinator]()
    lazy var presentationManager = PresentationManager()

    // MARK: - Init

    init(root: SidebarViewController, services: Services, eventTracker: EventTracker) {
        self.rootViewController = root
        self.services = services
        self.eventTracker = eventTracker
    }

    // MARK: - Coordinator -> Starts

    func start() {
        let libraryViewController = LibraryViewController(viewModel: LibraryViewModel())
        libraryViewController.delegate = self
        presentationManager.presentationType = .fadeIn
        libraryViewController.modalPresentationStyle = .custom
        libraryViewController.transitioningDelegate = presentationManager

        let topTabBarControllerItem = TopTabBarController.Item(
            controllers: [libraryViewController],
            titles: [R.string.localized.sidebarTitleLibrary()]
        )

        let topTabBarController = TopTabBarController(
            item: topTabBarControllerItem,            
            leftIcon: R.image.ic_minimize()
        )

        topTabBarController.delegate = self
        rootViewController.present(topTabBarController, animated: true)

        // TODO: Update associatedEntity with realm object when its created.
        
        eventTracker.track(page: libraryViewController.pageID, referer: rootViewController.pageID, associatedEntity: nil)
    }
}

// MARK: - LibraryViewControllerDelegate

extension LibraryCoordinator: LibraryViewControllerDelegate {

    func didTapMedia(with mediaItem: LibraryMediaItem, from view: UIView, in viewController: UIViewController) {
        log("didTapMedia: \(mediaItem)")
    }
}

// MARK: - TopTabBarDelegate

extension LibraryCoordinator: TopTabBarDelegate {

    func didSelectLeftButton(sender: TopTabBarController) {
        sender.dismiss(animated: true, completion: nil)
        removeChild(child: self)
    }

    func didSelectRightButton(sender: TopTabBarController) {
        print("didSelectRightButton")
    }

    func didSelectItemAtIndex(index: Int?, sender: TopTabBarController) {
        print("didSelectItemAtIndex")
    }
}
