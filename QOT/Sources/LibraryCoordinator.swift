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
    fileprivate let libraryViewController: LibraryViewController
    fileprivate let presentationManager: PresentationManager
    var children = [Coordinator]()

    // MARK: - Init

    init(root: SidebarViewController, services: Services) {
        self.rootViewController = root
        self.services = services
        
        presentationManager = PresentationManager(type: .fadeIn)
        presentationManager.presentationType = .fadeIn

        libraryViewController = LibraryViewController(viewModel: LibraryViewModel(services: services))
        libraryViewController.modalPresentationStyle = .custom
        libraryViewController.transitioningDelegate = presentationManager
        libraryViewController.title = R.string.localized.sidebarTitleLibrary()

        libraryViewController.delegate = self
    }
    
    func start() {
        rootViewController.present(libraryViewController, animated: true)
    }
}

// MARK: - LibraryViewControllerDelegate

extension LibraryCoordinator: LibraryViewControllerDelegate {

    func didTapLibraryItem(item: ContentCollection) {
        guard let coordinator = ArticleContentItemCoordinator(
            root: libraryViewController,
            services: services,
            contentCollection: item,
            articleHeader: nil,
            topTabBarTitle: R.string.localized.sidebarTitleLibrary().uppercased()) else {
                return
        }
        startChild(child: coordinator)
    }

    func didTapClose(in viewController: LibraryViewController) {
        viewController.dismiss(animated: true, completion: nil)
        removeChild(child: self)
    }

}
