//
//  VideoBookmarkTableViewCell.swift
//  QOT
//
//  Created by Sanggeon Park on 13.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

class VideoBookmarkTableViewCell: BaseMyLibraryTableViewCell, Dequeueable {
    @IBOutlet weak var preview: UIImageView!
    @IBOutlet weak var playButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        skeletonManager.addOtherView(preview)
    }

    func configure(withUrl: URL?) {
        guard let url = withUrl else { return }
        configure()
        skeletonManager.addOtherView(preview)
        preview.setImage(url: url, placeholder: R.image.preloading(), skeletonManager: self.skeletonManager)
    }
}
