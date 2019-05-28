//
//  AudioPlayerBar.swift
//  QOT
//
//  Created by karmic on 25.04.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class AudioPlayerBar: UIView {

    private let audioPlayer = AudioPlayer.current
    weak var viewDelegate: AudioPlayerViewDelegate?
    weak var toolViewDelegate: AudioToolPlayerDelegate?
    @IBOutlet weak var contentView: UIView!
    @IBOutlet private weak var progressView: UIProgressView!
    @IBOutlet private weak var playPauseButton: UIButton!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!

    // MARK: - Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        audioPlayer.delegate = self
        contentView.corner(radius: 20)
        progressView.corner(radius: 20)
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
        setTitleLabel(title: title)
        audioPlayer.resetPlayer()
        audioPlayer.prepareToPlay(categoryTitle: categoryTitle, title: title, audioURL: audioURL, remoteID: remoteID)
        if let titleColor = titleColor {
            titleLabel.textColor = titleColor.withAlphaComponent(0.7)
        }
    }

    func updateView() {
        audioPlayer.delegate = self
        playPauseButton.setImage(audioPlayer.isPlaying ? R.image.ic_pause_sand() : R.image.ic_play_sand(), for: .normal)
    }

    func setColorMode() {
        contentView.backgroundColor = colorMode.audioBackground
        setTitleLabel(title: titleLabel.text ?? "")
    }
}

// MARK: - Private

private extension AudioPlayerBar {
    func setTitleLabel(title: String) {
        titleLabel.attributedText = NSAttributedString(string: title.uppercased(),
                                                       letterSpacing: 0.4,
                                                       font: .apercuMedium(ofSize: 12),
                                                       textColor: UIColor.carbon.withAlphaComponent(0.6),
                                                       alignment: .left)
    }
}

// MARK: - Actions

private extension AudioPlayerBar {
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

    @IBAction func didTabCloseButton() {
        audioPlayer.resetPlayer()
        viewDelegate?.didTabClose(for: .bar)
        toolViewDelegate?.didTabClose(for: .bar)
    }

    @IBAction func didTabFullScreenButton() {
        viewDelegate?.openFullScreen()
        toolViewDelegate?.openFullScreen()
    }
}

// MARK: - AudioPlayerDelegate

extension AudioPlayerBar: AudioPlayerDelegate {
    func updateProgress(currentTime: Double, totalTime: Double, progress: Float) {
        guard progress.isNaN == false else { return }
        progressView.progress = progress
    }

    func updateControllButton(with image: UIImage?) {
        playPauseButton.setImage(image, for: .normal)
    }

    func didFinishAudio() {
        viewDelegate?.didFinishAudio()
        toolViewDelegate?.didFinishAudio()
    }
}
