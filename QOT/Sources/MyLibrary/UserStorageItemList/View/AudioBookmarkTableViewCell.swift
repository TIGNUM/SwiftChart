//
//  AudioBookmarkTableViewCell.swift
//  QOT
//
//  Created by Sanggeon Park on 13.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

class AudioBookmarkTableViewCell: UITableViewCell, BaseMyLibraryTableViewCellInterface, Dequeueable {
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var preview: UIImageView!
    @IBOutlet weak var contentTitle: UILabel!
    @IBOutlet weak var infoText: UILabel!
    @IBOutlet weak var playButton: UIButton!

    override func setSelected(_ selected: Bool, animated: Bool) {
        if self.isEditing {
            super.setSelected(selected, animated: animated)
        }
    }
}
