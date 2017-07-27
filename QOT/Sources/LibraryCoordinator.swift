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
    var children = [Coordinator]()
    lazy var presentationManager = PresentationManager(type: .fadeIn)

    // MARK: - Init

    init(root: SidebarViewController, services: Services) {
        self.rootViewController = root
        self.services = services
        self.libraryViewController = LibraryViewController(viewModel: LibraryViewModel(services: services))
    }

    // MARK: - Coordinator -> Starts

    func start() {
        libraryViewController.delegate = self
        libraryViewController.modalPresentationStyle = .custom
        libraryViewController.transitioningDelegate = presentationManager

        let topTabBarControllerItem = TopTabBarController.Item(
            controllers: [libraryViewController],
            themes: [.dark],
            titles: [R.string.localized.sidebarTitleLibrary()]
        )

        let topTabBarController = TopTabBarController(
            item: topTabBarControllerItem,            
            leftIcon: R.image.ic_minimize()
        )

        topTabBarController.delegate = self
        rootViewController.present(topTabBarController, animated: true)
    }
}

// MARK: - LibraryViewControllerDelegate

extension LibraryCoordinator: LibraryViewControllerDelegate {

    func didTapLibraryItem(item: ContentCollection) {
        let coordinator = ArticleContentItemCoordinator(
            root: libraryViewController,
            services: services,
            contentCollection: item,
            articleHeader: nil,
            topTabBarTitle: R.string.localized.sidebarTitleLibrary().uppercased()
        )
        startChild(child: coordinator)
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

    func didSelectItemAtIndex(index: Int, sender: TopTabBarController) {
        print("didSelectItemAtIndex")
    }
}
