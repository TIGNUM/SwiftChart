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

final class LearnStrategyAudioViewModel: NSObject {
    struct AudioItem {
        let title: String
        let playing: Bool
    }

    // MARK: - Properties

    fileprivate let item = audioStrategy
    fileprivate var currentIndex: Index = 0
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

    var soundPattern = Property<[CGFloat]?>(randomSoundPattern)

    var trackDuration = Property<TimeInterval?>(623)

    var currentPosition = Property<TimeInterval?>(200)

    func playItem(at index: Index) {
        log("did start to play item at index: \(index)")
    }

    func stopPlayback() {
        log("did stop playback")
    }

    func audioItem(at index: Index) -> AudioItem {
        return AudioItem(title: audioTrack(at: index).title, playing: index == 1)
    }

    private func audioTrack(at index: Index) -> AudioTrack {
        return item.tracks[index]
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
