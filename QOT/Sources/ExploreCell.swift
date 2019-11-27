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
    @IBOutlet weak var strategyView: UIView!
    @IBOutlet private weak var lineView: UIView!
    @IBOutlet private var hourLabels: [UILabel]!

    override func awakeFromNib() {
        super.awakeFromNib()
        baseHeaderView = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseHeaderView?.addTo(superview: headerView, showSkeleton: true)
        skeletonManager.addOtherView(strategyView)
        skeletonManager.addOtherView(lineView)
        for label in hourLabels {
            skeletonManager.addOtherView(label)
        }
    }

    func configure(title: String?, introText: String?, labelPosition: CGFloat?, bucketTitle: String?) {
        baseHeaderView?.configure(title: (bucketTitle ?? "").uppercased(), subtitle: introText)
        ThemeText.dailyBriefTitle.apply((bucketTitle ?? "").uppercased(), to: baseHeaderView?.titleLabel)
        ThemeText.dailyBriefSubtitle.apply(introText, to: baseHeaderView?.subtitleTextView)
        baseHeaderView?.subtitleTextViewBottomConstraint.constant = 0
        ThemeText.strategyTitle.apply((title ?? "").uppercased(), to: titleLabel)
        timeOfDayPosition.constant = labelPosition ?? 0
        skeletonManager.hide()
    }
}
