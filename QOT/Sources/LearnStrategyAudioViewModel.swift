//
//  LearnStrategyAudioViewModel.swift
//  QOT
//
//  Created by karmic on 21.04.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import ReactiveKit
import AVFoundation

final class LearnStrategyAudioViewModel {

    struct AudioItem {
        let title: String
        let playing: Bool
    }

    // MARK: - Properties

    var soundPattern = Property<[CGFloat]>(randomSoundPattern)
    var trackDuration = Property<TimeInterval>(623)
    var currentPosition = Property<TimeInterval>(0)
    fileprivate let item = audioStrategy
    fileprivate var currentIndex: Index = 0
    fileprivate var player = AVPlayer()
    fileprivate var timeObserver: Any?
    fileprivate var playingIndexPath: IndexPath?
    let updates = PublishSubject<CollectionUpdate, NoError>()

    var audioItemsCount: Int {
        return item.tracks.count
    }

    var headline: String {
        return item.headline
    }

    var subHeadline: String {
        return item.subHeadline
    } 

    func playItem(at indexPath: IndexPath) {

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
                play(url: audioTrack(at: indexPath.row).url)
            }
        } else {
            // play new
            playingIndexPath = indexPath
            modifications = [indexPath]
            play(url: audioTrack(at: indexPath.row).url)
        }

        updates.next(.update(deletions: [], insertions: [], modifications:modifications))
    }

    func stopPlayback() {
        log("did stop playback")
        player.pause()

        if let timeObserver = timeObserver {
            player.removeTimeObserver(timeObserver)
        }
    }

    func audioItem(at index: Index) -> AudioItem {
        let playing = playingIndexPath == nil ? false : (playingIndexPath!.row == index)

        return AudioItem(title: audioTrack(at: index).title, playing: playing)
    }

    private func audioTrack(at index: Index) -> AudioTrack {
        return item.tracks[index]
    }

    private func play(url: URL) {
        log("did start to play item at index: \(index)")
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

// MARK: - MockData

protocol AudioStrategy {
    var headline: String { get }
    var subHeadline: String { get }
    var tracks: [AudioTrack] { get }
}

protocol AudioTrack {
    var title: String { get }
    var url: URL { get }
    var soundPattern: [CGFloat] { get }
}

struct MockAudioStraregy: AudioStrategy {
    let headline: String
    let subHeadline: String
    let tracks: [AudioTrack]
}

struct MockAudioTrack: AudioTrack {
    let title: String
    let url: URL
    let soundPattern: [CGFloat]
}

private var audioStrategy: AudioStrategy {
    return MockAudioStraregy(
        headline: "OPTIMAL PERFORMANCE STATE",
        subHeadline: "Performance Mindset",
        tracks: audioTracks
    )
}

private var audioTracks: [AudioTrack] {
    return [
        MockAudioTrack(
            title: "Intro",
            url: URL(string: "http://extracoding.com/demo/wp/iloverockband/light/wp-content/uploads/2013/07/Lorem-ipsum-dolor-sit-amet1.mp3")!,
            soundPattern: randomSoundPattern
        ),

        MockAudioTrack(
            title: "Item 1",
            url: URL(string: "http://extracoding.com/demo/wp/iloverockband/light/wp-content/uploads/2013/07/Lorem-ipsum-dolor-sit-amet1.mp3")!,
            soundPattern: randomSoundPattern
        ),

        MockAudioTrack(
            title: "Item 2",
            url: URL(string: "http://extracoding.com/demo/wp/iloverockband/light/wp-content/uploads/2013/07/Lorem-ipsum-dolor-sit-amet1.mp3")!,
            soundPattern: randomSoundPattern
        ),

        MockAudioTrack(
            title: "Item 3",
            url: URL(string: "http://extracoding.com/demo/wp/iloverockband/light/wp-content/uploads/2013/07/Lorem-ipsum-dolor-sit-amet1.mp3")!,
            soundPattern: randomSoundPattern
        )
    ]
}

private var randomSoundPattern: [CGFloat] {
    var pattern = [CGFloat]()

    for _ in 0...1000 {
        let randomValue = CGFloat(Float(arc4random())/Float(UINT32_MAX))
        pattern.append(randomValue)
    }

    return pattern
}
