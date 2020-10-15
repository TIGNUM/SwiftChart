//
//  RateOpenCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 12.10.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class RateOpenCell: BaseDailyBriefCell {

    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var ctaButton: UIButton!
    @IBOutlet private weak var rateLabel: UILabel!
    private var baseHeaderView: QOTBaseHeaderView?
    weak var delegate: DailyBriefViewControllerDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        ctaButton.corner(radius: Layout.cornerRadius20, borderColor: .accent40)
        baseHeaderView = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseHeaderView?.addTo(superview: headerView, showSkeleton: true)
        skeletonManager.addSubtitle(rateLabel)
        skeletonManager.addOtherView(ctaButton)
    }

    func configure(model: RateOpenModel?) {
        skeletonManager.hide()
        ctaButton.setTitle(AppTextService.get(.daily_brief_rate_open_cta), for: .normal)
        let text = AppTextService.get(.daily_brief_rate_open_text).replacingOccurrences(of: "${team_admin}", with: model?.ownerEmail ?? "")
        let title = AppTextService.get(.daily_brief_vision_rating_title).replacingOccurrences(of: "${TEAM_NAME)", with: model?.team?.name ?? "")
        ThemeText.dailyInsightsTbvAdvice.apply(text, to: rateLabel)
        baseHeaderView?.configure(title: title, subtitle: nil)
        let teamColor = UIColor(hex: model?.team?.teamColor ?? "")
        baseHeaderView?.setColor(dashColor: teamColor, titleColor: teamColor, subtitleColor: nil)
    }
}
