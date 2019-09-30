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
    private let skeletonManager = SkeletonManager()

    override func awakeFromNib() {
        super.awakeFromNib()
        ThemeView.level2.apply(self)
        let bkgdView = UIView(frame: self.bounds)
        ThemeView.level2Selected.apply(bkgdView)
        selectedBackgroundView = bkgdView
        skeletonManager.addTitle(headingLabel)
        skeletonManager.addSubtitle(subHeadingLabel)
    }

    func configure(_ data: MyQotProfileModel.TableViewPresentationData?) {
        guard let model = data else { return }
        skeletonManager.hide()
        ThemeText.linkMenuItem.apply(model.heading.uppercased(), to: headingLabel)
        ThemeText.linkMenuComment.apply(model.subHeading, to: subHeadingLabel)
    }
}
