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
    private var avPlayerObserver: AVPlayerObserver?
}

// MARK: - MyLibraryBookmarksRouterInterface

extension MyLibraryUserStorageRouter: MyLibraryUserStorageRouterInterface {
    func presentVideo(url: URL, item: QDMContentItem?) {
        if let playerController = viewController?.stream(videoURL: url, contentItem: item),
            let player = playerController.player {
            avPlayerObserver = AVPlayerObserver(player: player)
            avPlayerObserver?.onChanges { [weak self] (player) in
                if player.timeControlStatus == .paused {
                    self?.viewController?.trackUserEvent(.PAUSE, value: item?.remoteID, valueType: .VIDEO, action: .TAP)
                }
                if player.timeControlStatus == .playing {
                    self?.viewController?.trackUserEvent(.PLAY, value: item?.remoteID, valueType: .VIDEO, action: .TAP)
                }
            }
        }
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
