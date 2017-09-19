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

final class LearnContentItemViewModel: NSObject {

    // MARK: - Properties

    fileprivate let services: Services
    fileprivate let relatedContentCollections: AnyRealmCollection<ContentCollection>
    fileprivate let recommentedContentCollections: AnyRealmCollection<ContentCollection>
    fileprivate let categoryID: Int
    fileprivate var playingIndexPath: IndexPath?
    fileprivate var timeObserver: Any?
    fileprivate var playerItemBufferEmptyObserver: Any?
    fileprivate var playerItemPlaybackObserver: Any?
    fileprivate var player: AVPlayer? = AVPlayer()
    fileprivate let eventTracker: EventTracker
    fileprivate var playerItem: AVPlayerItem?
    fileprivate(set) var isPlaying: Bool = false
    fileprivate var currentPlayingCell: LearnStrategyPlaylistAudioCell?
    weak var audioPlayerViewDelegate: AudioPlayerViewLabelDelegate?
    let contentCollection: ContentCollection
    var currentPosition = ReactiveKit.Property<TimeInterval>(0)
    lazy var trackDuration: ReactiveKit.Property<TimeInterval> = {
        let item = self.contentItems(at: TabType.audio).first
        let duration = item?.valueDuration.value.map { TimeInterval($0) }

        return ReactiveKit.Property<TimeInterval>(duration ?? 0)
    }()

    let updates = PublishSubject<CollectionUpdate, NoError>()

    // MARK: - Init

    init(services: Services, eventTracker: EventTracker, contentCollection: ContentCollection, categoryID: Int) {
        self.services = services
        self.eventTracker = eventTracker
        self.contentCollection = contentCollection
        self.categoryID = categoryID
        self.relatedContentCollections = services.contentService.contentCollections(ids: contentCollection.relatedContentIDs)
        self.recommentedContentCollections = services.contentService.contentCollections(categoryID: categoryID)

        super.init()

        setupAudioNotifications()
    }
    
    deinit {
        tearDownAudioNotifications()
        removeAudioItemObserver()
    }

    // MARK: - KVO AudioItem

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let playerItem = playerItem else {
            return
        }

        if keyPath == "playbackBufferEmpty" {
            if playerItem.isPlaybackBufferEmpty == true {
                currentPlayingCell?.updateItem(buffering: false, playing: isPlaying)
                audioPlayerViewDelegate?.stopBlinking()
            }
        } else if keyPath == "playbackLikelyToKeepUp" {
            if playerItem.isPlaybackLikelyToKeepUp == true {
                currentPlayingCell?.updateItem(buffering: false, playing: isPlaying)
                audioPlayerViewDelegate?.stopBlinking()
            }
        }
    }
}

// MARK: - Public

extension LearnContentItemViewModel {

    func sectionCount(tabType: TabType) -> Int {
        let sections = containsAudioItem(tabType: tabType) == true ? 2 : 1
        let relatedSectionCount = relatedContentCollections.count > 0 ? 1 : 0
        return sections + relatedSectionCount
    }

    func numberOfItemsInSection(in section: Int, tabType: TabType) -> Int {
        guard sectionCount(tabType: tabType) > 1 else {
            return contentItemsCount(at: tabType)
        }

        if sectionCount(tabType: tabType) == 3 {
            switch section {
            case 0: return 1
            case 1: return contentItemsCount(at: tabType)
            case 2: return relatedContentCollections.count > 3 ? 3 : relatedContentCollections.count
            default: return 0
            }
        } else if sectionCount(tabType: tabType) == 2 && containsAudioItem(tabType: tabType) == true {
            switch section {
            case 0: return 1
            case 1: return contentItemsCount(at: tabType)
            default: return 0
            }
        } else {
            switch section {
            case 0: return contentItemsCount(at: tabType)
            case 1: return relatedContentCollections.count > 3 ? 3 : relatedContentCollections.count
            default: return 0
            }
        }
    }

    fileprivate func contentItemsCount(at tabType: TabType) -> Int {
        var count = contentItems(at: tabType).count

        count += contentItems(at: tabType).filter({
            switch $0.contentItemValue {
            case .pdf: return true
            default: return false
            }
        }).count > 0 ? 1 : 0

        return count
    }

    func heightForRow(at section: Int, tabType: TabType) -> CGFloat {
        guard sectionCount(tabType: tabType) > 1 else {
            return UITableViewAutomaticDimension
        }

        if sectionCount(tabType: tabType) == 3 {
            switch section {
            case 0: return CGFloat(100)
            default: return UITableViewAutomaticDimension
            }
        } else if tabType == .audio && section == 1 {
            return 44
        } else if sectionCount(tabType: tabType) == 2 && containsAudioItem(tabType: tabType) == true {
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
        return contentItems(at: tabType).filter({
            switch $0.contentItemValue {
            case .pdf: return false
            default: return true
            }
        })[indexPath.row]
    }

    func learnPDFContentItem(at indexPath: IndexPath, tabType: TabType) -> ContentItem {
        let otherItems = contentItems(at: tabType).filter({
            switch $0.contentItemValue {
            case .pdf: return false
            default: return true
            }
        })

        return contentItems(at: tabType).filter({
            switch $0.contentItemValue {
            case .pdf: return true
            default: return false
            }
        })[indexPath.row - otherItems.count - 1]
    }

    func pdfCount(at indexPath: IndexPath, tabType: TabType) -> Int {
        return contentItems(at: tabType).filter({
            switch $0.contentItemValue {
            case .pdf: return true
            default: return false
            }
        }).count
    }

    func isReadMoreItem(at indexPath: IndexPath, tabType: TabType) -> Bool {
        return contentItems(at: tabType).filter({
            switch $0.contentItemValue {
            case .pdf: return false
            default: return true
            }
        }).count == indexPath.row
    }

    func isPDFItem(at indexPath: IndexPath, tabType: TabType) -> Bool {
        return contentItems(at: tabType).filter({
            switch $0.contentItemValue {
            case .pdf: return false
            default: return true
            }
        }).count < indexPath.row
    }

    func relatedContent(at indexPath: IndexPath) -> ContentCollection {
        return relatedContentCollections[indexPath.row]
    }

    func containsAudioItem(tabType: TabType) -> Bool {
        return contentItems(at: tabType).contains { (item: ContentItem) -> Bool in
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

    func didViewContentItem(localID: String) {
        services.contentService.setViewed(localID: localID)
        
        guard let contentItem = services.mainRealm.syncableObject(ofType: ContentItem.self, localID: localID) else {
            return
        }
        eventTracker.track(.didReadContentItem(contentItem))
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

        return player == nil ? false : player?.rate != 0
    }

    func playItem(at indexPath: IndexPath, audioURL: URL, duration: TimeInterval, cell: LearnStrategyPlaylistAudioCell?) {
        currentPlayingCell?.updateItem(buffering: false, playing: false)
        currentPlayingCell = cell
        trackDuration = Property(duration)
        let modifications: [IndexPath]
        if let current = playingIndexPath {
            if current == indexPath {
                // pause / unpause
                modifications = [indexPath]
                if isPlaying {
                    pausePlayback()
                } else {
                    unpausePlayback()
                }
            } else {
                // stop current
                // play new                
                modifications = [current, indexPath]
                stopPlayback()
                play(url: audioURL, cell: cell, playingIndexPath: indexPath)
            }
        } else {
            // play new
            modifications = [indexPath]
            play(url: audioURL, cell: cell, playingIndexPath: indexPath)
        }

        updates.next(.update(deletions: [], insertions: [], modifications: modifications))
    }
    
    func pausePlayback() {
        guard let playingIndexPath = playingIndexPath else {
            return
        }

        player?.pause()
        isPlaying = false
        updates.next(.update(deletions: [], insertions: [], modifications: [playingIndexPath]))
    }
    
    func unpausePlayback() {
        player?.play()
        isPlaying = true
        currentPlayingCell?.updateItem(buffering: false, playing: true)
    }

    func stopPlayback() {
        log("Did stop playback")

        removeAudioItemObserver()
        
        if let timeObserver = timeObserver {
            player?.removeTimeObserver(timeObserver)
        }

        player?.pause()
        playerItem = nil
        player = nil
        currentPosition.value = 0
        playingIndexPath = nil
        isPlaying = false
    }

    func forward(value: Float) {
        let time = TimeInterval(value) * trackDuration.value
        player?.seek(to: CMTimeMakeWithSeconds(time, 1))
        player?.play()
        isPlaying = true
    }
    
    // MARK: - private

    private func play(url: URL, cell: LearnStrategyPlaylistAudioCell?, playingIndexPath: IndexPath?) {
        log("Did start to play item at index: \(index)")

        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        } catch let error {
            print("Error while trying to set catgeory for AVAudioSession: ", error)
        }

        removeAudioItemObserver()
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        self.playerItem = playerItem
        self.playingIndexPath = playingIndexPath
        cell?.updateItem(buffering: true, playing: true)
        audioPlayerViewDelegate?.startBlinking()
        player?.volume = 1.0
        player?.play()
        isPlaying = true
        observePlayerTime()
        observePlayerItem()
    }

    private func observePlayerTime() {
        timeObserver = player?.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1), queue: .main) { (time: CMTime) in
            self.currentPosition.value = time.seconds
        }
    }

    private func observePlayerItem() {
        if let playerItem = playerItem {
            playerItemBufferEmptyObserver = playerItem.addObserver(self, forKeyPath: "playbackBufferEmpty", options: .new, context: nil)
            playerItemPlaybackObserver = playerItem.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options: .new, context: nil)
        }
    }

    // MARK: - notification
    
    fileprivate func setupAudioNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidEndNotification(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    fileprivate func tearDownAudioNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }

    fileprivate func removeAudioItemObserver() {
        if  playerItemBufferEmptyObserver != nil && playerItemPlaybackObserver != nil {
            playerItem?.removeObserver(self, forKeyPath: "playbackLikelyToKeepUp")
            playerItem?.removeObserver(self, forKeyPath: "playbackBufferEmpty")
        }
    }

    @objc fileprivate func playerDidEndNotification(_ notification: Notification) {
        guard let playingIndexPath = playingIndexPath else {
            return
        }
        stopPlayback()
        updates.next(.update(deletions: [], insertions: [], modifications: [playingIndexPath]))
    }
}
