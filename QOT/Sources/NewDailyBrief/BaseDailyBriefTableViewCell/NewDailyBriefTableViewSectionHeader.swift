//
//  NewDailyBriefTableViewSectionHeader.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 30.11.2020.
//  Copyright © 2020 Tignum. All rights reserved.
//

import Foundation
import qot_dal

class NewDailyBriefTableViewSectionHeader: UITableViewHeaderFooterView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleTopConstraint: NSLayoutConstraint!
    let skeletonManager = SkeletonManager()

    func configure(title: String?) {
        guard let titleText = title else {
            skeletonManager.addTitle(titleLabel)
            log("[DaiBriLOG: NewDailyBriefTableViewSectionHeader] configure -> title == nil; return ", level: .error)
            return
        }
        skeletonManager.hide()
        titleLabel.text = "/" + titleText
    }
}
