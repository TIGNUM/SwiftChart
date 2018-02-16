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
    @IBOutlet weak private var audioSpinner: UIActivityIndicatorView!

    // MARK: - Setup

    func setup(title: String, playing: Bool) {
        titleLabel.font = UIFont.bentonBookFont(ofSize: 16)
        titleLabel.textColor = playing == true ? .blue : .black
        titleLabel.text = title
        iconView.image = playing == true ? R.image.ic_pause() : R.image.ic_play()
        audioSpinner.stopAnimating()
    }
}

// MARK: - Update Indicator & Playbutton

extension LearnStrategyPlaylistAudioCell {

    func updateItem(buffering: Bool, playing: Bool) {
        iconView.image = playing == true ? R.image.ic_pause() : R.image.ic_play()

        if buffering == true {
            iconView.isHidden = true
            audioSpinner.startAnimating()
        } else {
            iconView.isHidden = false
            audioSpinner.stopAnimating()
        }
    }

    func updateTitleColor(enabled: Bool) {
        titleLabel.textColor = enabled == true ? .blue : .black
    }

    func resetPlayIcon() {
        iconView.image = R.image.ic_play()
    }

    func getAudioTitle() -> String {
        guard let title = titleLabel.text else { return "" }

        return title
    }
}
