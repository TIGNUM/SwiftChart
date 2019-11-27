//
//  AudioPlayerBar.swift
//  QOT
//
//  Created by karmic on 25.04.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class AudioPlayerBar: UIView {

    public enum Mode {
        case playPause
        case progress
    }

    private let audioPlayer = AudioPlayer.current
    @IBOutlet weak var contentView: UIView!
    @IBOutlet private weak var progressView: UIProgressView!
    @IBOutlet private weak var playPauseButton: UIButton!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!

    // Full Screen Mode
    @IBOutlet private weak var progressModeContentView: UIView!
    @IBOutlet private weak var verticalDivider: UIView!
    @IBOutlet private weak var progressModeSlider: UISlider!
    @IBOutlet private weak var progressModeProgressView: UIProgressView!
    @IBOutlet private weak var currentTimeLabel: UILabel!
    @IBOutlet private weak var totalTimeLabel: UILabel!

    @IBOutlet private weak var sliderLeading: NSLayoutConstraint!
    @IBOutlet private weak var sliderTrailing: NSLayoutConstraint!

    private var currentMedia: MediaPlayerModel?
    private var isLightMode: Bool = false

    var isPlaying: Bool {
        return audioPlayer.isPlaying
    }

    // MARK: - Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        audioPlayer.delegate = self
        contentView.corner(radius: 20)
        progressView.corner(radius: 20)
        progressModeContentView.corner(radius: 20)
        progressModeProgressView.corner(radius: 20)
        progressModeSlider.setThumbImage(R.image.ic_audio_slider(), for: .normal)
        let thumbImageWidth: CGFloat = progressModeSlider.thumbImage(for: .normal)?.size.width ?? 0
        sliderLeading.constant = -(thumbImageWidth/2)
        sliderTrailing.constant = -(thumbImageWidth/2)
        progressModeContentView.corner(radius: 20)
        refreshColorMode(isLight: isLightMode)
    }

    static func instantiateFromNib() -> AudioPlayerBar {
        guard let audioPlayerBar = R.nib.audioPlayerBar.instantiate(withOwner: self).first as? AudioPlayerBar else {
            fatalError("Cannot load audio player view")
        }
        return audioPlayerBar
    }

    func configure(categoryTitle: String, title: String, audioURL: URL?, remoteID: Int, titleColor: UIColor? = nil) {
        audioPlayer.delegate = self
        progressView.progress = 0
        setTitleLabel(title: title, isLight: isLightMode)
        audioPlayer.resetPlayer()
        audioPlayer.prepareToPlay(categoryTitle: categoryTitle, title: title, audioURL: audioURL, remoteID: remoteID)
        if let titleColor = titleColor {
            titleLabel.textColor = titleColor.withAlphaComponent(0.7)
        }

        progressModeSlider.setThumbImage(R.image.ic_audio_slider(), for: .normal)
    }

    func updateView() {
        audioPlayer.delegate = self
        playPauseButton.setImage(audioPlayer.isPlaying ? R.image.ic_pause_sand() : R.image.ic_play_sand(), for: .normal)
    }

    func refreshColorMode(isLight: Bool) {
        isLightMode = isLight
        setTitleLabel(title: titleLabel.text ?? "", isLight: isLight)
        contentView.backgroundColor = (isLight) ? .carbon : .sand
        progressModeContentView.backgroundColor = (isLight) ? .carbon : .sand
        verticalDivider.backgroundColor = (isLight) ? .sand60 : .carbon60
    }
}

// MARK: - Private

private extension AudioPlayerBar {
    func setTitleLabel(title: String, isLight: Bool) {
        if isLight {
        ThemeText.audioPlayerTitleLight.apply(title.uppercased(), to: titleLabel)
        } else {  ThemeText.audioPlayerTitleDark.apply(title.uppercased(), to: titleLabel)}
    }
}

extension AudioPlayerBar {
    func playPause(_ media: MediaPlayerModel) {
        if media.mediaRemoteId == currentMedia?.mediaRemoteId {
            if audioPlayer.isPlaying {
                trackUserEvent(.PAUSE)
                audioPlayer.pause()
            } else {
                trackUserEvent(.PLAY)
                audioPlayer.play()
            }
        } else {
            if currentMedia?.mediaRemoteId != nil {
                audioPlayer.resetPlayer()
            }
            progressModeSlider.isUserInteractionEnabled = false
            currentMedia = media
            audioPlayer.delegate = self
            progressView.progress = 0
            setTitleLabel(title: media.title, isLight: isLightMode)

            audioPlayer.prepareToPlay(categoryTitle: media.subtitle,
                                      title: media.title,
                                      audioURL: media.url,
                                      remoteID: media.mediaRemoteId)
            audioPlayer.play()
            trackUserEvent(.PLAY)
        }
    }

    func cancel() {
        audioPlayer.cancel()
        currentMedia = nil
    }

    func setBarMode(_ mode: AudioPlayerBar.Mode) {
        switch mode {
        case .playPause:
            progressModeContentView.isUserInteractionEnabled = false
            UIView.animate(withDuration: 0.25) {
                self.progressModeContentView.alpha = 0
            }
        case .progress:
            progressModeContentView.isUserInteractionEnabled = true
            UIView.animate(withDuration: 0.25) {
                self.progressModeContentView.alpha = 1
            }
        }
    }

    func updateProgress(progress: Float) {
        UIView.animate(withDuration: 0.25) {
            self.progressView.progress = progress
            self.progressModeProgressView.progress = progress
        }
    }

    func updateTimeValues(currentTime: Double, totalTime: Double, isLight: Bool) {
        if isLight {
            ThemeText.audioPlayerTime.apply(timeString(for: currentTime), to: currentTimeLabel)
            ThemeText.audioPlayerTime.apply(timeString(for: totalTime), to: totalTimeLabel)

        } else {
            ThemeText.audioPlayerTimeLight.apply(timeString(for: currentTime), to: currentTimeLabel)
            ThemeText.audioPlayerTimeLight.apply(timeString(for: totalTime), to: totalTimeLabel)
        }
    }

    private func timeString(for seconds: Double) -> String {
        return String(format: "%02i:%02i", Int(seconds) / 60 % 60, Int(seconds) % 60)
    }

    func trackUserEvent(_ name: QDMUserEventTracking.Name) {
        var userEventTrack = QDMUserEventTracking()
        userEventTrack.name = name
        userEventTrack.value = currentMedia?.mediaRemoteId
        userEventTrack.valueType = .AUDIO
        userEventTrack.action = .TAP
        NotificationCenter.default.post(name: .reportUserEvent, object: userEventTrack)
    }
}

// MARK: - Actions

private extension AudioPlayerBar {
    @IBAction func didTapPlayPauseButton() {
        guard let media = currentMedia  else {
            return
        }
        NotificationCenter.default.post(name: .playPauseAudio, object: media)
        trackUserEvent(isPlaying ? .PAUSE : .PLAY)
    }

    @IBAction func didTapCloseButton() {
        NotificationCenter.default.post(name: .stopAudio, object: nil)
        trackUserEvent(.CLOSE)
    }

    @IBAction func didTapFullScreenButton() {
        NotificationCenter.default.post(name: .showAudioFullScreen, object: currentMedia)
        trackUserEvent(.FULL_SCREEN)
    }

    @IBAction func sliderValueDidChange(_ sender: UISlider) {
        trackUserEvent(.AUDIO_SEEK)
        updateProgress(progress: sender.value)
        audioPlayer.seek(to: sender.value)
    }
}

// MARK: - AudioPlayerDelegate

extension AudioPlayerBar: AudioPlayerDelegate {
    func updateProgress(currentTime: Double, totalTime: Double, progress: Float) {
        guard progress.isNaN == false else { return }
        updateProgress(progress: progress)
        progressModeSlider.setValue(progress, animated: true)
        progressModeSlider.isUserInteractionEnabled = true
        updateTimeValues(currentTime: currentTime, totalTime: totalTime, isLight: isLightMode)
    }

    func updateControllButton(with image: UIImage?) {
        playPauseButton.setImage(image, for: .normal)
    }

    func didFinishAudio() {
        audioPlayer.resetPlayer()
        audioPlayer.prepareToPlay(categoryTitle: currentMedia?.subtitle ?? "",
                                  title: currentMedia?.title ?? "",
                                  audioURL: currentMedia?.url,
                                  remoteID: currentMedia?.mediaRemoteId ?? 0)
        audioPlayer.pause()
    }
}
