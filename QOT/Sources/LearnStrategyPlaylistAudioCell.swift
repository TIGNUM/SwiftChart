//
//  LearnStrategyPlaylistAudioCell.swift
//  QOT
//
//  Created by tignum on 4/26/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class LearnStrategyPlaylistAudioCell: UITableViewCell, Dequeueable {

    // MARK: - Properties

    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var iconView: UIImageView!
    @IBOutlet weak private var seperatorView: UIView!
    @IBOutlet weak private var audioSpinner: UIActivityIndicatorView!
    private let pauseImage = R.image.ic_pause()?.withRenderingMode(.alwaysTemplate)
    private let playImage = R.image.ic_play()?.withRenderingMode(.alwaysTemplate)

    // MARK: - Setup

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        audioSpinner.color = .nightModeMainFont
        seperatorView.backgroundColor = .nightModeBlack30
    }

    func setup(title: String, playing: Bool) {
        titleLabel.font = UIFont.bentonBookFont(ofSize: 16)
        titleLabel.text = title
        updateStateImage(playing)
        updateTitleColor(enabled: playing)
        audioSpinner.stopAnimating()
    }
}

// MARK: - Update Indicator & Playbutton

extension LearnStrategyPlaylistAudioCell {

    func updateItem(buffering: Bool, playing: Bool) {
        updateStateImage(playing)
        if buffering == true {
            iconView.isHidden = true
            audioSpinner.startAnimating()
        } else {
            iconView.isHidden = false
            audioSpinner.stopAnimating()
        }
    }

    func updateTitleColor(enabled: Bool) {
        titleLabel.textColor = enabled == true ? .nightModeBlue : .nightModeBlack
    }

    func resetPlayIcon() {
        updateStateImage(false)
    }

    func getAudioTitle() -> String {
        guard let title = titleLabel.text else { return "" }
        return title
    }
}

// MARK: - Private

private extension LearnStrategyPlaylistAudioCell {

    func updateStateImage(_ playing: Bool) {
        iconView.image = playing == true ? pauseImage : playImage
        iconView.tintColor = .nightModeBlack
    }
}
