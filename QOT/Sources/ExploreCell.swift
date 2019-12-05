//
//  ExploreCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 11.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class ExploreCell: BaseDailyBriefCell {

    @IBOutlet var headerHeightConstraint: NSLayoutConstraint!
    private var baseHeaderView: QOTBaseHeaderView?
    @IBOutlet weak var headerView: UIView!
    @IBOutlet private weak var timeOfDayPosition: NSLayoutConstraint!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var strategyTitleLabel: UILabel!
    @IBOutlet private weak var exploreButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        baseHeaderView = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseHeaderView?.addTo(superview: headerView, showSkeleton: true)
        skeletonManager.addSubtitle(strategyTitleLabel)
        skeletonManager.addOtherView(exploreButton)
    }

    func configure(title: String?, introText: String?, bucketTitle: String?) {
        baseHeaderView?.configure(title: (bucketTitle ?? "").uppercased(), subtitle: introText)
        ThemeText.dailyBriefTitle.apply((bucketTitle ?? "").uppercased(), to: baseHeaderView?.titleLabel)
        ThemeText.dailyBriefSubtitle.apply(introText, to: baseHeaderView?.subtitleTextView)
        baseHeaderView?.subtitleTextViewBottomConstraint.constant = 0
        ThemeText.strategyTitle.apply((title ?? "").uppercased(), to: strategyTitleLabel)
        skeletonManager.hide()
    }
}
