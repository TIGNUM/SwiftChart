//
//  AudioPlayer.swift
//  QOT
//
//  Created by karmic on 25.04.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import MediaPlayer

protocol AudioPlayerDelegate: class {
    func updateProgress(currentTime: Double, totalTime: Double, progress: Float)
    func updateControllButton(with image: UIImage?)
    func didFinishAudio()
}

class AudioPlayer {

    enum View {
        case bar
        case fullScreen
    }

    // MARK: - Properties

    static let current = AudioPlayer()
    private var _audioURL: URL?
    private var _remoteID: Int = 0
    private var _categoryTitle = ""
    private var _title = ""
    private var _currentTime = Double(0)
    private var _totalTime = Double(0)
    private var _progress = Float(0)
    private var _isPlaying = false
    private var _isReset = true
    private var player: AVPlayer?
    private var playerItem: AVPlayerItem?
    private var updater: CADisplayLink?
    weak var delegate: AudioPlayerDelegate?

    var media: MediaPlayerModel {
        return MediaPlayerModel(title: _title, subtitle: categoryTitle,
                                url: _audioURL,
                                totalDuration: _totalTime, progress: _progress, currentTime: _currentTime,
                                mediaRemoteId: _remoteID)
    }

    var audioURL: URL? {
        return _audioURL
    }

    var remoteID: Int {
        return _remoteID
    }

    var categoryTitle: String {
        return _categoryTitle
    }

    var title: String {
        return _title
    }

    var isPlaying: Bool {
        return _isPlaying
    }

    var duration: Double {
        return _totalTime
    }

    // MARK: - Private Init

    private init() {}

    func seek(to seconds: Float) {
        let time = TimeInterval(seconds) * _totalTime
        player?.seek(to: CMTimeMakeWithSeconds(time, preferredTimescale: 1))
    }

    func resetPlayer() {
        _isReset = true
        _isPlaying = false
        player?.pause()
        player?.seek(to: CMTimeMakeWithSeconds(0, preferredTimescale: 1))
        delegate?.updateControllButton(with: R.image.ic_play_sand())
        updater?.invalidate()
    }

    func pause() {
        _isPlaying = false
        _isReset = false
        updater?.isPaused = true
        player?.pause()
        delegate?.updateControllButton(with: R.image.ic_play_sand())
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .didPauseAudio, object: self.media)
        }
    }

    func play() {
        if player?.currentItem != nil {
            player?.automaticallyWaitsToMinimizeStalling = false
            player?.play()
            _isPlaying = true
            _isReset = false
            delegate?.updateControllButton(with: R.image.ic_pause())
            updater?.isPaused = false
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .didStartAudio, object: self.media)
                self.setupNowPlaying()
                self.setupRemoteCommandCenter()
            }
        }
    }

    func setRate(_ rate: Float) {
        player?.rate = rate
    }

    func cancel() {
        resetPlayer()
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .didStopAudio, object: self.media)
        }
    }

    func prepareToPlay(categoryTitle: String, title: String, audioURL: URL?, remoteID: Int) {
        _categoryTitle = categoryTitle
        _title = title
        _audioURL = audioURL
        _remoteID = remoteID
        if player?.timeControlStatus == .playing {
            player?.pause()
            _isPlaying = false
            delegate?.updateControllButton(with: R.image.ic_play_sand())
            updater?.invalidate()
        } else {
            guard let audioURL = audioURL else { return }
            let playerItem = AVPlayerItem(url: audioURL)
            self.playerItem = playerItem
            player = AVPlayer(playerItem: playerItem)
            delegate?.updateControllButton(with: R.image.ic_pause())
            _isReset = false
            try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback,
                                                             mode: AVAudioSession.Mode.default,
                                                             options: .init(rawValue: 0))
            try? AVAudioSession.sharedInstance().setActive(true)
        }
        updater = CADisplayLink(target: self, selector: #selector(trackAudio))
        updater?.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
    }

    func setupNowPlaying() {
        var nowPlayingInfo = [String: Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = title
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = _currentTime
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = playerItem?.asset.duration.seconds
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = player?.rate
        if #available(iOS 13.0, *) {
            MPNowPlayingInfoCenter.default().playbackState = .playing
        }
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }

    func setupRemoteCommandCenter() {
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget {_ in
            self.player?.play()
            return .success
        }
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget {_ in
            self.player?.pause()
            self.pause()
            return .success
        }
        commandCenter.togglePlayPauseCommand.isEnabled = true
    }

    @objc func trackAudio() {
        guard let currentTime = player?.currentItem?.currentTime().seconds,
            let duration = player?.currentItem?.duration.seconds else {
                return
        }
        _currentTime = currentTime
        _totalTime = duration
        _progress = Float(currentTime/duration)
        delegate?.updateProgress(currentTime: _currentTime, totalTime: _totalTime, progress: _progress)
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .didUpdateAudioPlayProgress, object: self.media)
        }
        if _progress >= 0.999 {
            updater?.invalidate()
            delegate?.updateControllButton(with: R.image.ic_play_sand())
            markAudioItemAsComplete(remoteID: _remoteID)
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .didEndAudio, object: self.media)
            }
        }
    }

    func markAudioItemAsComplete(remoteID: Int) {
        if UserDefault.finishedAudioItems.object as? [Int] == nil {
            UserDefault.finishedAudioItems.setObject([Int]())
        }
        if var items = UserDefault.finishedAudioItems.object as? [Int] {
            items.append(remoteID)
            UserDefault.finishedAudioItems.setObject(items)
            delegate?.didFinishAudio()
        }
    }
}
