//
//  ExploreCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 11.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class ExploreCell: BaseDailyBriefCell {

    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet private weak var timeOfDayPosition: NSLayoutConstraint!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var strategyTitleLabel: UILabel!
    @IBOutlet private weak var exploreButton: AnimatedButton!
    private var contentID: Int?
    private var isStrategy = true
    private weak var baseHeaderView: QOTBaseHeaderView?
    weak var delegate: DailyBriefViewController?

    override func awakeFromNib() {
        super.awakeFromNib()
        ThemeBorder.accent40.apply(exploreButton)
        skeletonManager.addOtherView(exploreButton)
        baseHeaderView = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseHeaderView?.addTo(superview: headerView, showSkeleton: true)
        skeletonManager.addSubtitle(strategyTitleLabel)
        exploreButton.setButtonContentInset(padding: 16)
    }

    func configure(title: String?, introText: String?, bucketTitle: String?, isStrategy: Bool, remoteID: Int?) {
        baseHeaderView?.configure(title: (bucketTitle ?? "").uppercased(), subtitle: introText)
        baseHeaderView?.subtitleTextViewBottomConstraint.constant = 0
        ThemeText.dailyBriefTitle.apply((bucketTitle ?? "").uppercased(), to: baseHeaderView?.titleLabel)
        ThemeText.dailyBriefSubtitle.apply(introText, to: baseHeaderView?.subtitleTextView)
        ThemeText.strategyTitle.apply((title ?? "").uppercased(), to: strategyTitleLabel)
        let exploreButtonText =  AppTextService.get(AppTextKey("daily_brief.section_explore.button"))
        exploreButton.setTitle(exploreButtonText, for: .normal)
        skeletonManager.hide()
        self.contentID = remoteID
        self.isStrategy = isStrategy
    }

    override func updateConstraints() {
        super.updateConstraints()
        baseHeaderView?.subtitleTextViewBottomConstraint.constant = 0
    }

    @IBAction func didTapExplore(_ sender: Any) {
        if isStrategy {
            delegate?.presentStrategyList(strategyID: self.contentID)
        } else {
            delegate?.openTools(toolID: self.contentID)
        }
    }
}
