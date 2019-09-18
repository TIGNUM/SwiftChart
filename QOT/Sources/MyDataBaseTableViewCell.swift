//
//  MyDataBaseTableViewCell.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 24/08/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import SkeletonView

class MyDataBaseTableViewCell: UITableViewCell, Dequeueable {
    var skeletonManager = SkeletonManager()

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        SkeletonAppearance.default.multilineHeight = 14.0
        SkeletonAppearance.default.multilineSpacing = 3.0
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        skeletonManager = SkeletonManager()
        SkeletonAppearance.default.multilineHeight = 14.0
        SkeletonAppearance.default.multilineSpacing = 3.0
    }
}
