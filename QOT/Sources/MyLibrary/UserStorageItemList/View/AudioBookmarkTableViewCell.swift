//
//  AudioBookmarkTableViewCell.swift
//  QOT
//
//  Created by Sanggeon Park on 13.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

class AudioBookmarkTableViewCell: BaseMyLibraryTableViewCell {
    @IBOutlet weak var playButton: RoundedButton!

    override func setSelected(_ selected: Bool, animated: Bool) {
        if self.isEditing {
            super.setSelected(selected, animated: animated)
        }
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        playButton.isEnabled = !editing
    }

    func configure(playButtonTitle: String?, playButtonTag: Int = .zero) {
        configure()
        ThemeButton.carbonButton.apply(playButton)
        playButton.setTitle(playButtonTitle)
        playButton.tag = playButtonTag
    }
}
