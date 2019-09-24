//
//  MyQotProfileHeaderView.swift
//  QOT
//
//  Created by Ashish Maheshwari on 06.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class MyQotProfileHeaderView: UITableViewHeaderFooterView, Dequeueable {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var memberSinceLabel: UILabel!
    let skeletonManager = SkeletonManager()

    override func awakeFromNib() {
        super.awakeFromNib()
        ThemeView.level2.apply(self)
        skeletonManager.addTitle(nameLabel)
        skeletonManager.addSubtitle(memberSinceLabel)
    }

    func configure(data: MyQotProfileModel.HeaderViewModel?) {
        guard let model = data, let name = model.name, let memberSince = model.memberSince else { return }
        skeletonManager.hide()
        ThemeText.myQOTProfileName.apply(name, to: nameLabel)
        ThemeText.datestamp.apply(memberSince, to: memberSinceLabel)
    }
}
