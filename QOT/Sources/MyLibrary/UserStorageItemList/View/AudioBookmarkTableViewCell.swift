//
//  AudioBookmarkTableViewCell.swift
//  QOT
//
//  Created by Sanggeon Park on 13.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

class AudioBookmarkTableViewCell: BaseMyLibraryTableViewCell {
    @IBOutlet weak var playButton: UIButton!

    override func setSelected(_ selected: Bool, animated: Bool) {
        if self.isEditing {
            super.setSelected(selected, animated: animated)
        }
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        playButton.isEnabled = !editing
    }

    func configure(playButtonTitle: String?, playButtonTag: Int = 0) {
        configure()
        playButton.setTitle(playButtonTitle, for: .normal)
        playButton.tag = playButtonTag
    }
}
