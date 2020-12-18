//
//  TBVDataGraphSubHeadingTableViewCell.swift
//  QOT
//
//  Created by Ashish Maheshwari on 28.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class TBVDataGraphSubHeadingTableViewCell: UITableViewCell, Dequeueable {

    @IBOutlet weak var title: UILabel!
    private var skeletonManager = SkeletonManager()

    override func awakeFromNib() {
        super.awakeFromNib()
        skeletonManager.addTitle(title)
    }

    func configure(subHeading: String?, showSkeleton: Bool) {
        ThemeText.tbvTrackerBody.apply(subHeading, to: title)
        if !showSkeleton {
            skeletonManager.hide()
        }
    }
}
