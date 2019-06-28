//
//  AudioFullScreenViewController.swift
//  QOT
//
//  Created by Sanggeon Park on 28.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class AudioFullScreenViewController: UIViewController {

    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var categorytitleLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var downloadButton: UIButton!
    @IBOutlet private weak var bookmarkButton: UIButton!

    @IBOutlet private weak var playPauseButton: UIButton!

    var media: MediaPlayerModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(didStartAudio(_:)), name: .didStartAudio, object: nil)
        notificationCenter.addObserver(self, selector: #selector(didPauseAudio(_:)), name: .didPauseAudio, object: nil)
        notificationCenter.addObserver(self, selector: #selector(didStopAudio(_:)), name: .didStopAudio, object: nil)
        notificationCenter.addObserver(self, selector: #selector(didEndAudio(_:)), name: .didEndAudio, object: nil)

        view.backgroundColor = .carbonDark

        setupButtons()
        updateLabel()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
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

    func updateLabel() {
        categorytitleLabel.attributedText = NSAttributedString(string: media?.subtitle ?? "",
                                                               letterSpacing: 0.4,
                                                               font: .apercuMedium(ofSize: 12),
                                                               textColor: colorMode.text.withAlphaComponent(0.3),
                                                               alignment: .left)
        titleLabel.attributedText = NSAttributedString(string: media?.title ?? "",
                                                       letterSpacing: 0.2,
                                                       font: .apercuLight(ofSize: 34),
                                                       textColor: colorMode.text,
                                                       alignment: .left)
    }

    func updatePlayButton(_ isPlaying: Bool) {
        playPauseButton.isSelected = isPlaying
    }

    func configureMedia(_ media: MediaPlayerModel, isPlaying: Bool = true) {
        self.media = media
        if self.view != nil {
            updatePlayButton(isPlaying)
            updateLabel()
        }
    }

}

// MARK: - Actions
extension AudioFullScreenViewController {
    @IBAction func didTabCloseButton() {
        trackUserEvent(.CLOSE, value: media?.mediaRemoteId, valueType: .AUDIO, action: .TAP)
        NotificationCenter.default.post(name: .hideAudioFullScreen, object: media)
        self.dismiss(animated: true)
    }

    @IBAction func didTabPlayPauseButton() {
        NotificationCenter.default.post(name: .playPauseAudio, object: media)
        trackUserEvent(playPauseButton.isSelected ? .PAUSE : .PLAY,
                       value: media?.mediaRemoteId, valueType: .AUDIO, action: .TAP)
    }
}

// MARK: - Notifications

extension AudioFullScreenViewController {
    @objc func didStartAudio(_ notification: Notification) {
        updatePlayButton(true)
    }

    @objc func didStopAudio(_ notification: Notification) {
        updatePlayButton(false)
        self.dismiss(animated: true)
    }

    @objc func didPauseAudio(_ notification: Notification) {
        updatePlayButton(false)
    }

    @objc func didEndAudio(_ notification: Notification) {
        updatePlayButton(false)
    }
}

// MARK: Bottom Navigation
extension AudioFullScreenViewController {

    @objc override public func bottomNavigationLeftBarItems() -> [UIBarButtonItem]? {
        return nil
    }

    @objc override public func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        return nil
    }
}
