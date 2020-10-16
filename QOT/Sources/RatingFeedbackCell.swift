//
//  RatingFeedbackCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 12.10.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class RatingFeedbackCell: BaseDailyBriefCell {

    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var averageLabel: UILabel!
    @IBOutlet private weak var averageValueLabel: UILabel!
    @IBOutlet private weak var feedbackLabel: UILabel!
    @IBOutlet private weak var resultsButton: UIButton!
    private var baseHeaderView: QOTBaseHeaderView?
    weak var delegate: DailyBriefViewControllerDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        resultsButton.corner(radius: Layout.cornerRadius20, borderColor: .accent40)
        baseHeaderView = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseHeaderView?.addTo(superview: headerView, showSkeleton: true)
        skeletonManager.addSubtitle(feedbackLabel)
        skeletonManager.addOtherView(resultsButton)
        skeletonManager.addOtherView(averageValueLabel)
        skeletonManager.addOtherView(averageLabel)
    }

    func configure(model: RatingFeedbackModel?) {
        skeletonManager.hide()
        resultsButton.setTitle(AppTextService.get(.daily_brief_rating_ready_cta), for: .normal)
        let title = AppTextService.get(.daily_brief_vision_rating_title).replacingOccurrences(of: "${TEAM_NAME}", with: model?.teamName ?? "").uppercased()
        ThemeText.dailyInsightsTbvAdvice.apply(model?.feedback, to: feedbackLabel)
        ThemeText.iRscore.apply(String(model?.averageValue ?? 0), to: averageValueLabel)
        let subtitle = AppTextService.get(.daily_brief_rating_ready_subtitle)
        baseHeaderView?.configure(title: title, subtitle: subtitle)
        baseHeaderView?.setColor(dashColor: model?.teamColor, titleColor: model?.teamColor, subtitleColor: .sand)
        ThemeText.baseHeaderSubtitleBold.apply(AppTextService.get(.daily_brief_rating_ready_average_title), to: averageLabel)
        ThemeText.baseHeaderSubtitleBold.apply(subtitle, to: baseHeaderView?.subtitleTextView)
    }

    override func updateConstraints() {
        super.updateConstraints()
        baseHeaderView?.subtitleTextViewBottomConstraint.constant = 0
    }
}
