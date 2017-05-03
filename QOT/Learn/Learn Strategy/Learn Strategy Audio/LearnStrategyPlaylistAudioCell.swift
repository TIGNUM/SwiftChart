//
//  LearnStrategyPlaylistAudioCell.swift
//  QOT
//
//  Created by tignum on 4/26/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

class LearnStrategyPlaylistAudioCell: UITableViewCell, Dequeueable {

    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var iconView: UIImageView!

    func setUp(title: String, playing: Bool) {
        titleLabel.font = UIFont.bentonBookFont(ofSize: 16)
        titleLabel.text =  title
        iconView.backgroundColor = playing == true ? .red : .blue
    }
}
