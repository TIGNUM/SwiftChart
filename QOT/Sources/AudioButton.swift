//
//  AudioButton.swift
//  QOT
//
//  Created by karmic on 03.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class AudioButton: UIView {

    // MARK: - Properties

    @IBOutlet private weak var durationLabel: UILabel!
    @IBOutlet private weak var audioIcon: UIImageView!
    @IBOutlet private weak var button: UIButton!
    private var categoryTitle = ""
    private var title = ""
    private var audioURL: URL?
    private var audioRemoteID: Int = .zero
    private var duration: Int = .zero

    static func instantiateFromNib() -> AudioButton {
        guard let audioButton = R.nib.audioButton.instantiate(withOwner: self).first as? AudioButton else {
            fatalError("Cannot load audio button view")
        }
        return audioButton
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        corner(radius: 20)
        self.layer.borderWidth = 1.0
    }

    func configure(categoryTitle: String,
                   title: String,
                   audioURL: URL?,
                   remoteID: Int,
                   duration: Int) {
        self.categoryTitle = categoryTitle
        self.title = title
        self.audioURL = audioURL
        self.audioRemoteID = remoteID
        self.duration = duration
        setColorMode()
    }

    func setColorMode() {
        let color = ThemeView.articleAudioBar.color
        self.layer.borderColor = color.cgColor
        audioIcon?.tintColor = color
        self.backgroundColor = colorMode == .dark ? .black : .white
        showDuration(duration)
    }
}

// MARK: - Private

private extension AudioButton {
    func showDuration(_ duration: Int) {
        let text = String(format: "%i:%02i", Int(duration) / 60 % 60, Int(duration) % 60)
        ThemeText.articleAudioBar.apply(text, to: durationLabel)
    }
}

// MARK: - Actions

private extension AudioButton {
    @IBAction func didTapAudioButton() {
        let media = MediaPlayerModel(title: title,
                                     subtitle: categoryTitle,
                                     url: audioURL,
                                     totalDuration: Double(duration), progress: .zero, currentTime: .zero, mediaRemoteId: audioRemoteID)
        NotificationCenter.default.post(name: .playPauseAudio, object: media)
    }
}
