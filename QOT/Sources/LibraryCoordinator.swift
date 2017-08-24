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

    fileprivate let services: Services
    fileprivate let libraryViewController: LibraryViewController
    fileprivate let rootViewController: UIViewController
    var children = [Coordinator]()

    // MARK: - Init

    init(root: SidebarViewController, services: Services) {
        self.rootViewController = root
        self.services = services
        libraryViewController = LibraryViewController(viewModel: LibraryViewModel(services: services))
        libraryViewController.title = R.string.localized.sidebarTitleLibrary()
        libraryViewController.delegate = self
    }
    
    func start() {
        rootViewController.pushToStart(childViewController: libraryViewController)
    }
}

// MARK: - LibraryViewControllerDelegate

extension LibraryCoordinator: LibraryViewControllerDelegate {

    func didTapLibraryItem(item: ContentCollection) {
        guard let coordinator = ArticleContentItemCoordinator(
            pageName: .libraryArticle,
            root: libraryViewController,
            services: services,
            contentCollection: item,            
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
