//
//  MyLibraryBookmarkTableViewCell.swift
//  QOT
//
//  Created by Sanggeon Park on 12.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

class ArticleBookmarkTableViewCell: BaseMyLibraryTableViewCell, Dequeueable {
    @IBOutlet weak var preview: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        skeletonManager.addTitle(contentTitle)
        skeletonManager.addSubtitle(infoText)
        skeletonManager.addOtherView(icon)
        skeletonManager.addOtherView(preview)
    }

    func configure(withUrl: URL?) {
        guard let url = withUrl else { return }
        skeletonManager.addOtherView(preview)
        preview.setImage(url: url, placeholder: R.image.preloading(), skeletonManager: self.skeletonManager)
    }
}
