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
    private weak var viewDelegate: AudioPlayerViewDelegate?
    private var categoryTitle = ""
    private var title = ""
    private var audioURL: URL? = nil
    private var remoteID: Int = 0

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
                   duration: Int,
                   viewDelegate: AudioPlayerViewDelegate?) {
        self.categoryTitle = categoryTitle
        self.title = title
        self.audioURL = audioURL
        self.remoteID = remoteID
        self.viewDelegate = viewDelegate
        let mediaDescription = String(format: "%02i:%02i", Int(duration) / 60 % 60, Int(duration) % 60)
        durationLabel.attributedText = NSAttributedString(string: mediaDescription,
                                                          letterSpacing: 0.4,
                                                          font: .apercuMedium(ofSize: 12),
                                                          textColor: .sand,
                                                          alignment: .center)
    }
}

// MARK: - Actions

private extension AudioButton {
    @IBAction func didTabAudiButton() {
        viewDelegate?.didTabPlayPause(categoryTitle: categoryTitle,
                                      title: title,
                                      audioURL: audioURL,
                                      remoteID: remoteID)
    }
}
