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

        var articleHeader: ArticleCollectionHeader?

        let title = item.contentCategories.first?.title
        let subtitle = item.title
        let date = DateFormatter.shortDate.string(from: item.createdAt)
        let duration = "\(item.items.reduce(0, { $0.0 + $0.1.secondsRequired }) / 60) MIN"

        articleHeader = ArticleCollectionHeader(
            articleTitle: title != nil ? title! : "",
            articleSubTitle: subtitle,
            articleDate: date,
            articleDuration: duration,
            articleContentCollection: item
        )

        guard let coordinator = ArticleContentItemCoordinator(
            pageName: .libraryArticle,
            root: libraryViewController,
            services: services,
            contentCollection: item,
            articleHeader: articleHeader,
            topTabBarTitle: R.string.localized.sidebarTitleLibrary().uppercased(),
            contentInsets: UIEdgeInsets(top: 46, left: 0, bottom: 0, right: 0)) else {
                return
        }
        startChild(child: coordinator)
    }

    func didTapClose(in viewController: LibraryViewController) {
        viewController.dismiss(animated: true, completion: nil)
        removeChild(child: self)
    }
}
