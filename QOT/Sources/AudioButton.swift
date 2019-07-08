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
    private var audioURL: URL? = nil
    private var audioRemoteID: Int = 0
    private var duration: Int = 0

    static func instantiateFromNib() -> AudioButton {
        guard let audioButton = R.nib.audioButton.instantiate(withOwner: self).first as? AudioButton else {
            fatalError("Cannot load audio button view")
        }
        return audioButton
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        corner(radius: 20)
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
        let mediaDescription = String(format: "%02i:%02i", Int(duration) / 60 % 60, Int(duration) % 60)
        setDutationLabel(text: mediaDescription)
        setColorMode()
    }

    func setColorMode() {
        backgroundColor = colorMode.tint.withAlphaComponent(0.3)
     }
}

// MARK: - Private

private extension AudioButton {
    func setDutationLabel(text: String) {
        durationLabel.attributedText = NSAttributedString(string: text,
                                                          letterSpacing: 0.4,
                                                          font: .apercuMedium(ofSize: 12),
                                                          textColor: colorMode.tint,
                                                          alignment: .center)
    }
}

// MARK: - Actions

private extension AudioButton {
    @IBAction func didTapAudiButton() {
        let media = MediaPlayerModel(title: title,
                                     subtitle: categoryTitle,
                                     url: audioURL,
                                     totalDuration: Double(duration), progress: 0, currentTime: 0, mediaRemoteId: audioRemoteID)
        NotificationCenter.default.post(name: .playPauseAudio, object: media)
    }
}
