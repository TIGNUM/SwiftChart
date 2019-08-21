//
//  MyLibraryBookmarksRouter.swift
//  QOT
//
//  Created by Sanggeon Park on 12.06.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

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
        let articleNavigationController = UINavigationController(rootViewController: articleViewController)
        articleNavigationController.navigationBar.isTranslucent = false
        viewController.present(articleNavigationController, animated: true, completion: nil)
    }

    func presentVideo(url: URL, item: QDMContentItem?) {
        // FIXME: Set correct pageName
        viewController.stream(videoURL: url, contentItem: item)
    }

    func presentExternalUrl(_ url: URL) {
        UIApplication.shared.open(url)
    }

    func presentCreateNote(noteId: String?) {
        guard let noteController = R.storyboard.myLibraryNotes.myLibraryNotesViewController() else {
            return
        }
        let configurator = MyLibraryNotesConfigurator.make()
        configurator(noteController, noteId)
        viewController.present(noteController, animated: true, completion: nil)
    }
}
