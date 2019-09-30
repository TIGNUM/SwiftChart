//
//  MyDataBaseTableViewCell.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 24/08/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

class MyDataBaseTableViewCell: UITableViewCell, Dequeueable {
    var skeletonManager = SkeletonManager()

    override func awakeFromNib() {
        super.awakeFromNib()
        skeletonManager = SkeletonManager()
        self.backgroundColor = .clear
    }
}
