//
//  AudioBookmarkTableViewCell.swift
//  QOT
//
//  Created by Sanggeon Park on 13.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

class AudioBookmarkTableViewCell: BaseMyLibraryTableViewCell, BaseMyLibraryTableViewCellInterface, Dequeueable {
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

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        playButton.isEnabled = !editing
    }

    func configure(withUrl: URL?, playButtonTitle: String?, playButtonTag: Int = 0) {
        guard let url = withUrl, let title = playButtonTitle else { return }
        skeletonManager.hide()
        preview.setImage(url: url, placeholder: R.image.preloading(), skeletonManager: skeletonManager)
        playButton.setTitle(playButtonTitle, for: .normal)
        playButton.tag = playButtonTag
    }
}
