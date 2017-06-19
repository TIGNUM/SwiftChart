//
//  LearnContentItemViewModel.swift
//  QOT
//
//  Created by karmic on 29/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import ReactiveKit
import AVFoundation

enum TabType: String {
    case full
    case bullets
    case audio
}

final class LearnContentItemViewModel {

    // MARK: - Properties

    fileprivate let contentCollection: LearnContentCollection
    fileprivate let relatedContentCollections: DataProvider<LearnContentCollection>
    fileprivate let recommentedContentCollections: DataProvider<LearnContentCollection>
    fileprivate var playingIndexPath: IndexPath?
    fileprivate var player = AVPlayer()
    fileprivate var timeObserver: Any?
    var currentPosition = Property<TimeInterval>(0)
    var trackDuration = Property<TimeInterval>(0)
    let updates = PublishSubject<CollectionUpdate, NoError>()

    // MARK: - Init

    init(
        contentCollection: LearnContentCollection,
        relatedContentCollections: DataProvider<LearnContentCollection>,
        recommentedContentCollections: DataProvider<LearnContentCollection>) {
            self.contentCollection = contentCollection
            self.relatedContentCollections = relatedContentCollections
            self.recommentedContentCollections = recommentedContentCollections
    }
}

// MARK: - Public

extension LearnContentItemViewModel {

    func sectionCount(_ tabType: TabType) -> Int {
        switch tabType {
        case .audio: return relatedContentCollections.count > 0 ? 3 : 2
        case .bullets,
             .full: return relatedContentCollections.count > 0 ? 2 : 1
        }
    }

    func numberOfItemsInSection(in section: Int, tabType: TabType) -> Int {
        guard sectionCount(tabType) > 1 else {
            return contentItems(at: tabType).count
        }

        switch tabType {
        case .audio:
            switch section {
            case 0: return 1
            case 1: return contentItems(at: tabType).count
            case 2: return relatedContentCollections.count > 3 ? 3 : relatedContentCollections.count
            default: return 0
            }
        case .bullets,
             .full:
            switch section {
            case 0: return contentItems(at: tabType).count
            case 1: return relatedContentCollections.count > 3 ? 3 : relatedContentCollections.count
            default: return 0
            }
        }
    }

    func contentItems(at tabType: TabType) -> [LearnContentItem] {
        return contentCollection.contentItems.items.filter { $0.tabs.contains(tabType.rawValue) }
    }

    func learnContentItem(at indexPath: IndexPath, tabType: TabType) -> LearnContentItem {
        return contentItems(at: tabType)[indexPath.row]
    }

    func relatedContent(at indexPath: IndexPath) -> LearnContentCollection {
        return relatedContentCollections.item(at: indexPath.row)
    }

    var format: String {
        return ""
    }

    var contentItemTextStyle: ContentItemTextStyle {
        return ContentItemTextStyle.h1
    }
    
    var remoteID: Int {
        return 0
    }
}

// MARK: - Audio

extension LearnContentItemViewModel {

    func isPlaying(indexPath: IndexPath) -> Bool {
        guard indexPath == playingIndexPath else {
            return false
        }

        return player.rate != 0
    }

    func playItem(at indexPath: IndexPath, audioURL: URL, duration: TimeInterval) {
        trackDuration = Property(duration)
        let modifications: [IndexPath]
        if let current = playingIndexPath {
            if current == indexPath {
                // stop
                playingIndexPath = nil
                modifications = [indexPath]
                stopPlayback()
            } else {
                // stop current
                // play new
                playingIndexPath = indexPath
                modifications = [current, indexPath]
                stopPlayback()
                play(url: audioURL)
            }
        } else {
            // play new
            playingIndexPath = indexPath
            modifications = [indexPath]
            play(url: audioURL)
        }

        updates.next(.update(deletions: [], insertions: [], modifications:modifications))
    }

    func stopPlayback() {
        log("Did stop playback")
        player.pause()

        if let timeObserver = timeObserver {
            player.removeTimeObserver(timeObserver)
        }
    }

    func forward(value: Float) {
        let time = TimeInterval(value) * trackDuration.value
        player.seek(to: CMTimeMakeWithSeconds(time, 1))
        player.play()
    }

    private func play(url: URL) {
        log("Did start to play item at index: \(index)")

        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        player.volume = 1.0
        player.play()
        observePlayerTime()
    }

    private func observePlayerTime() {
        timeObserver = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: .main) { (time: CMTime) in
            self.currentPosition.value = time.seconds
        }
    }
}
