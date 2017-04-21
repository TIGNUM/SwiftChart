//
//  LearnStrategyAudioViewModel.swift
//  QOT
//
//  Created by karmic on 21.04.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import ReactiveKit

final class LearnStrategyAudioViewModel {

    // MARK: - Properties

    private let item = audioStrategy
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

    func audioTrack(at index: Index) -> AudioTrack {
        return item.tracks[index]
    }

    func soundPattern(at index: Index) -> [CGFloat] {
        return audioTrack(at: index).soundPattern
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
    var length: CGFloat { get }
    var soundPattern: [CGFloat] { get }
}

struct MockAudioStraregy: AudioStrategy {
    let headline: String
    let subHeadline: String
    let tracks: [AudioTrack]
}

struct MockAudioTrack: AudioTrack {
    let title: String
    let length: CGFloat
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
            length: 1023,
            soundPattern: randomSoundPattern
        ),

        MockAudioTrack(
            title: "Item 1",
            length: 959,
            soundPattern: randomSoundPattern
        ),

        MockAudioTrack(
            title: "Item 2",
            length: 1332,
            soundPattern: randomSoundPattern
        ),

        MockAudioTrack(
            title: "Item 3",
            length: 512,
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
