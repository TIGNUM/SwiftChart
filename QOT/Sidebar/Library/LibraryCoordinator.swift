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

    internal var rootViewController: SidebarViewController?
    fileprivate let services: Services
    fileprivate let eventTracker: EventTracker?
    internal var children = [Coordinator]()
    weak var delegate: ParentCoordinator?
    lazy var presentationManager = PresentationManager()

    init(root: SidebarViewController, services: Services, eventTracker: EventTracker?) {
        self.rootViewController = root
        self.services = services
        self.eventTracker = eventTracker
    }

    func start() {
        let libraryViewController = LibraryViewController(viewModel: LibraryViewModel())
        libraryViewController.delegate = self
        presentationManager.presentationType = .fadeIn
        libraryViewController.modalPresentationStyle = .custom
        libraryViewController.transitioningDelegate = presentationManager
        rootViewController?.present(libraryViewController, animated: true)

        // TODO: Update associatedEntity with realm object when its created.
        eventTracker?.track(page: libraryViewController.pageID, referer: rootViewController?.pageID, associatedEntity: nil)
    }
}

// MARK: - LibraryViewControllerDelegate

extension LibraryCoordinator: LibraryViewControllerDelegate {

    func didTapMedia(with mediaItem: LibraryItem.MediaItem, from view: UIView, in viewController: UIViewController) {
        log("didTapMedia: \(mediaItem)")
    }

    func didTapClose(in viewController: LibraryViewController) {
        viewController.dismiss(animated: true, completion: nil)
        delegate?.removeChild(child: self)
    }
}
