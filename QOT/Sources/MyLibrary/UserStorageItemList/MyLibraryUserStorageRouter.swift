//
//  MyLibraryBookmarksRouter.swift
//  QOT
//
//  Created by Sanggeon Park on 12.06.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class MyLibraryUserStorageRouter: BaseRouter {

}

// MARK: - MyLibraryBookmarksRouterInterface

extension MyLibraryUserStorageRouter: MyLibraryUserStorageRouterInterface {
    func presentVideo(url: URL, item: QDMContentItem?) {
        viewController?.stream(videoURL: url, contentItem: item)
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
        viewController?.present(noteController, animated: true, completion: nil)
    }
}
