//
//  MyQotProfileOptionsTableViewCell.swift
//  QOT
//
//  Created by Ashish Maheshwari on 06.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class MyQotProfileOptionsTableViewCell: UITableViewCell, Dequeueable {

    @IBOutlet private weak var headingLabel: UILabel!
    @IBOutlet private weak var subHeadingLabel: UILabel!
    @IBOutlet private weak var separator: UIView!
    @IBOutlet weak var customAccessoryImageView: UIImageView!
    private let skeletonManager = SkeletonManager()

    override func awakeFromNib() {
        super.awakeFromNib()
        ThemeView.level2.apply(self)
        selectionStyle = .none
        skeletonManager.addTitle(headingLabel)
        skeletonManager.addSubtitle(subHeadingLabel)
    }

    func configure(title: String?, subtitle: String?) {
        guard let heading = title else { return }
        selectionStyle = .default
        let bkgdView = UIView(frame: self.bounds)
        ThemeView.level2Selected.apply(bkgdView)
        selectedBackgroundView = bkgdView
        skeletonManager.hide()
        ThemeText.linkMenuItem.apply(heading, to: headingLabel)
        ThemeText.linkMenuComment.apply(subtitle, to: subHeadingLabel)
    }
}
