//
//  Notification+MediaPlayer.swift
//  QOT
//
//  Created by Sanggeon Park on 27.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

// MARK: - Handle Audio
extension Notification.Name {
    static let playPauseAudio = Notification.Name("playAudio")
    static let stopAudio = Notification.Name("stopAudio")
}

// MARK: - Update current Audio Player Status
extension Notification.Name {
    static let didStartAudio = Notification.Name("didStartAudio")
    static let didPauseAudio = Notification.Name("didPauseAudio")
    static let didStopAudio = Notification.Name("didStopAudio")
    static let didEndAudio = Notification.Name("didEndAudio")
    static let didUpdateAudioPlayProgress = Notification.Name("didUpdateAudioPlayProgress")
}

// MARK: - Update Player Mode
extension Notification.Name {
    static let showAudioFullScreen = Notification.Name("showAudioFullScreen")
    static let hideAudioFullScreen = Notification.Name("dismissAudioFullScreen")
}
