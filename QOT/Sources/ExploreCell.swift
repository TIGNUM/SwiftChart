//
//  ExploreCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 11.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class ExploreCell: BaseDailyBriefCell {

    @IBOutlet private weak var bucketTitle: UILabel!
    @IBOutlet private weak var timeOfDayPosition: NSLayoutConstraint!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var introTextLabel: UILabel!
    @IBOutlet weak var strategyView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        skeletonManager.addSubtitle(introTextLabel)
        skeletonManager.addOtherView(strategyView)
    }

    func configure(title: String?, introText: String?, labelPosition: CGFloat?, bucketTitle: String?) {
        ThemeText.dailyBriefTitle.apply((bucketTitle ?? "").uppercased(), to: self.bucketTitle)
        ThemeText.dailyBriefSubtitle.apply(introText, to: introTextLabel)
        ThemeText.strategyTitle.apply((title ?? "").uppercased(), to: titleLabel)
        timeOfDayPosition.constant = labelPosition ?? 0
        skeletonManager.hide()
    }
}
