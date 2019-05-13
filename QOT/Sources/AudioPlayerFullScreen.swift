//
//  AudioPlayerFullScreen.swift
//  QOT
//
//  Created by karmic on 25.04.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class AudioPlayerFullScreen: UIView {

    // MARK: - Properties

    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var categorytitleLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var currentTimeLabel: UILabel!
    @IBOutlet private weak var totalTimeLabel: UILabel!
    @IBOutlet private weak var downloadButton: UIButton!
    @IBOutlet private weak var bookmarkButton: UIButton!
    @IBOutlet private weak var playPauseButton: UIButton!
    @IBOutlet private weak var audioPlayerContentView: UIView!
    @IBOutlet private weak var verticalDivider: UIView!
    @IBOutlet private weak var audioSlider: UISlider!
    @IBOutlet private weak var audioProgressView: UIProgressView!
    @IBOutlet private weak var visualEffectView: UIVisualEffectView!
    private let audioPlayer = AudioPlayer.current
    weak var viewDelegate: AudioPlayerViewDelegate?

    static func instantiateFromNib() -> AudioPlayerFullScreen {
        guard let audioPlayer = R.nib.audioPlayerFullScreen.instantiate(withOwner: self).first as? AudioPlayerFullScreen else {
            fatalError("Cannot load audio player view")
        }
        return audioPlayer
    }

    func configure() {
        setupView()
        verticalDivider.backgroundColor = colorMode.audioText
        audioPlayer.delegate = self
        audioSlider.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)
        categorytitleLabel.attributedText = NSAttributedString(string: audioPlayer.categoryTitle,
                                                               letterSpacing: 0.4,
                                                               font: .apercuMedium(ofSize: 12),
                                                               textColor: colorMode.text.withAlphaComponent(0.3),
                                                               alignment: .left)
        titleLabel.attributedText = NSAttributedString(string: audioPlayer.title,
                                                       letterSpacing: 0.2,
                                                       font: .apercuLight(ofSize: 34),
                                                       textColor: colorMode.text,
                                                       alignment: .left)
        playPauseButton.setImage(audioPlayer.isPlaying ? R.image.ic_pause_sand() : R.image.ic_play_sand(), for: .normal)
        visualEffectView.effect = UIBlurEffect(style: colorMode.audioVissualEffect)
        drawCircles()
    }
}

// MARK: - Private

private extension AudioPlayerFullScreen {
    func setupView() {
        setupPlayerBar()
        setupButtons()
        updateTimeValues(currentTime: 0, totalTime: 0)
    }

    func setupPlayerBar() {
        audioSlider.setThumbImage(R.image.ic_audio_slider(), for: .normal)
        audioPlayerContentView.backgroundColor = colorMode.audioBackground
        audioPlayerContentView.corner(radius: 20)
    }

    func setupButtons() {
        downloadButton.backgroundColor = .clear
        downloadButton.layer.borderWidth = 1
        downloadButton.layer.borderColor = UIColor.accent30.cgColor
        downloadButton.setAttributedTitle(NSAttributedString(string: "Download",
                                                             letterSpacing: 0.4,
                                                             font: .apercuBold(ofSize: 12),
                                                             textColor: .accent,
                                                             alignment: .left),
                                          for: .normal)
        bookmarkButton.backgroundColor = .accent30
        downloadButton.corner(radius: 20)
        bookmarkButton.corner(radius: 20)
    }

    func drawCircles() {
        drawSolidCircle(arcCenter: center, radius: 50, strokeColor: .sand30)
        drawSolidCircle(arcCenter: center, radius: 70, strokeColor: .sand20)
        drawSolidCircle(arcCenter: center, radius: 100, strokeColor: .accent10)
        drawSolidCircle(arcCenter: center, radius: 140, strokeColor: .accent10)
    }

    func updateTimeValues(currentTime: Double, totalTime: Double) {
        currentTimeLabel.attributedText = NSAttributedString(string: timeString(for: currentTime),
                                                             letterSpacing: 0.4,
                                                             font: .apercuMedium(ofSize: 12),
                                                             textColor: colorMode.audioText,
                                                             alignment: .right)
        totalTimeLabel.attributedText = NSAttributedString(string: timeString(for: totalTime),
                                                           letterSpacing: 0.4,
                                                           font: .apercuMedium(ofSize: 12),
                                                           textColor: colorMode.audioText,
                                                           alignment: .left)
    }

    func updateProgress(progress: Float) {
        audioProgressView.progress = progress
        audioSlider.setValue(progress, animated: true)
    }

    func timeString(for seconds: Double) -> String {
        return String(format: "%02i:%02i", Int(seconds) / 60 % 60, Int(seconds) % 60)
    }
}

// MARK: - Actions

extension AudioPlayerFullScreen {
    @IBAction func didTabCloseButton() {
        viewDelegate?.didTabClose(for: .fullScreen)
    }

    @IBAction func didTabPlayPauseButton() {
        if audioPlayer.isPlaying == true {
            audioPlayer.pause()
        } else if audioPlayer.isReset == true {
            audioPlayer.prepareToPlay(categoryTitle: audioPlayer.categoryTitle,
                                      title: audioPlayer.title,
                                      audioURL: audioPlayer.audioURL,
                                      remoteID: audioPlayer.remoteID)
        } else {
            audioPlayer.play()
        }
    }

    @objc func sliderValueDidChange(_ sender: UISlider) {
        updateProgress(progress: sender.value)
        audioPlayer.seek(to: sender.value)
    }
}

extension AudioPlayerFullScreen: AudioPlayerDelegate {
    func updateProgress(currentTime: Double, totalTime: Double, progress: Float) {
        updateTimeValues(currentTime: currentTime, totalTime: totalTime)
        updateProgress(progress: progress)
    }

    func updateControllButton(with image: UIImage?) {
        playPauseButton.setImage(image, for: .normal)
    }

    func didFinishAudio() {
        viewDelegate?.didFinishAudio()
    }
}
