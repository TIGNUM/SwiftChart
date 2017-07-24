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
import RealmSwift

enum TabType: String {
    case full = "FULL"
    case bullets = "BULLETS"
    case audio = "AUDIO"

    static func allTabs(for items: [ContentItem]) -> [TabType] {
        var tabs = [TabType]()

        items.forEach { (item: ContentItem) in
            item.tabs.components(separatedBy: ",").forEach({ (tab: String) in
                let tabType = TabType(rawValue: tab) ?? .full
                if tabs.contains(tabType) == false {
                    tabs.append(tabType)
                }
            })
        }

        return tabs
    }
}

final class LearnContentItemViewModel {

    // MARK: - Properties

    fileprivate let services: Services
    fileprivate let contentCollection: ContentCollection
    fileprivate let relatedContentCollections: AnyRealmCollection<ContentCollection>
    fileprivate let recommentedContentCollections: AnyRealmCollection<ContentCollection>
    fileprivate let categoryID: Int
    fileprivate var playingIndexPath: IndexPath?
    fileprivate var player = AVPlayer()
    fileprivate var timeObserver: Any?
    var currentPosition = ReactiveKit.Property<TimeInterval>(0)
    var trackDuration = ReactiveKit.Property<TimeInterval>(0)
    let updates = PublishSubject<CollectionUpdate, NoError>()

    // MARK: - Init

    init(services: Services, contentCollection: ContentCollection, categoryID: Int) {
        self.services = services
        self.contentCollection = contentCollection
        self.categoryID = categoryID
        self.relatedContentCollections = services.contentService.contentCollections(ids: contentCollection.relatedContentIDs)
        self.recommentedContentCollections = services.contentService.contentCollections(categoryID: categoryID)
    }
}

// MARK: - Public

extension LearnContentItemViewModel {

    func sectionCount() -> Int {
        let sections = containsAudioItem() == true ? 2 : 1
        let relatedSectionCount = relatedContentCollections.count > 0 ? 1 : 0
        return sections + relatedSectionCount
    }

    func numberOfItemsInSection(in section: Int, tabType: TabType) -> Int {
        guard sectionCount() > 1 else {
            return contentItems(at: tabType).count
        }

        if sectionCount() == 3 {
            switch section {
            case 0: return 1
            case 1: return contentItems(at: tabType).count
            case 2: return relatedContentCollections.count > 3 ? 3 : relatedContentCollections.count
            default: return 0
            }
        } else if sectionCount() == 2 && containsAudioItem() == true {
            switch section {
            case 0: return 1
            case 1: return contentItems(at: tabType).count
            default: return 0
            }
        } else {
            switch section {
            case 0: return contentItems(at: tabType).count
            case 1: return relatedContentCollections.count > 3 ? 3 : relatedContentCollections.count
            default: return 0
            }
        }
    }

    func heightForRow(at section: Int) -> CGFloat {
        guard sectionCount() > 1 else {
            return UITableViewAutomaticDimension
        }

        if sectionCount() == 3 {
            switch section {
            case 0: return CGFloat(100)
            default: return UITableViewAutomaticDimension
            }
        } else if sectionCount() == 2 && containsAudioItem() == true {
            switch section {
            case 0: return CGFloat(100)
            default: return UITableViewAutomaticDimension
            }
        } else {
            return UITableViewAutomaticDimension
        }
    }

    func contentItems(at tabType: TabType) -> [ContentItem] {
        return contentCollection.contentItems.filter { $0.tabs.contains(tabType.rawValue) }
    }

    func learnContentItem(at indexPath: IndexPath, tabType: TabType) -> ContentItem {
        return contentItems(at: tabType)[indexPath.row]
    }

    func relatedContent(at indexPath: IndexPath) -> ContentCollection {
        return relatedContentCollections[indexPath.row]
    }

    func containsAudioItem() -> Bool {
        return contentCollection.contentItems.contains { (item: ContentItem) -> Bool in
            switch item.contentItemValue {
            case .audio: return true
            default: return false
            }
        }
    }

    func firstAudioItem() -> ContentItemValue {
        return contentCollection.contentItems.filter { (item: ContentItem) -> Bool in
            switch item.contentItemValue {
            case .audio: return true
            default:  return false
            }
        }[0].contentItemValue
    }

    func didViewContentItem(id: Int) {
        services.contentService.setViewed(itemID: id)
    }

    var format: String {
        return ""
    }

    var contentTitle: String {
        return contentCollection.title
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
