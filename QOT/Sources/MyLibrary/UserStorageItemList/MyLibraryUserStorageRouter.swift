//
//  MyLibraryBookmarksRouter.swift
//  QOT
//
//  Created by Sanggeon Park on 12.06.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class MyLibraryUserStorageRouter {

    // MARK: - Properties

    private let viewController: MyLibraryUserStorageViewController

    // MARK: - Init

    init(viewController: MyLibraryUserStorageViewController) {
        self.viewController = viewController
    }
}

// MARK: - MyLibraryBookmarksRouterInterface

extension MyLibraryUserStorageRouter: MyLibraryUserStorageRouterInterface {
    func presentArticle(id: Int) {
        guard let articleViewController = R.storyboard.main.qotArticleViewController() else {
            assertionFailure("Failed to initialize `ArticleViewController`")
            return
        }
        ArticleConfigurator.configure(selectedID: id, viewController: articleViewController)
        viewController.present(articleViewController, animated: true, completion: nil)
    }

    func presentVideo(url: URL) {
        // FIXME: Set correct pageName
        viewController.stream(videoURL: url, contentItem: nil, pageName: PageName.myPreparations)
    }

    func presentExternalUrl(_ url: URL) {
        UIApplication.shared.open(url)
    }

    func presentCreateNote() {
        // TODO: Show note creation screen
    }
}
