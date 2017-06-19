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

    // MARK: - Setup

    func setUp(title: String, playing: Bool) {
        titleLabel.font = UIFont.bentonBookFont(ofSize: 16)
        titleLabel.text = title
        iconView.image = playing == true ? R.image.ic_pause() : R.image.ic_play()
    }
}
