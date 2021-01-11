//
//  TeamToBeVisionCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 30.07.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class TeamToBeVisionCell: BaseDailyBriefCell {

    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var ctaButton: AnimatedButton!
    @IBOutlet private weak var toBeVisionLabel: UILabel!
    private var team: QDMTeam?
    weak var delegate: DailyBriefViewControllerDelegate?
    private weak var baseHeaderView: QOTBaseHeaderView?

    override func awakeFromNib() {
        super.awakeFromNib()
        baseHeaderView = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseHeaderView?.addTo(superview: headerView, showSkeleton: true)
        skeletonManager.addOtherView(ctaButton)
        skeletonManager.addSubtitle(toBeVisionLabel)
    }

    func configure(with viewModel: TeamToBeVisionCellViewModel?) {
        guard let model = viewModel else { return }
        skeletonManager.hide()
        self.team = model.team
        let subtitle = AppTextService.get(.daily_brief_team_to_be_vision_subtitle)
        baseHeaderView?.configure(title: (model.title ?? "").uppercased(), subtitle: subtitle)
        baseHeaderView?.subtitleTextViewBottomConstraint.constant = 0
        let titleColor = UIColor(hex: model.team?.teamColor ?? "")
        baseHeaderView?.setColor(dashColor: titleColor, titleColor: titleColor, subtitleColor: nil)
        ThemeText.dailyBriefFromTignumTitle.apply(subtitle, to: baseHeaderView?.subtitleTextView)
        ThemeText.bespokeText.apply(model.teamVision, to: toBeVisionLabel)
        let ctaText = AppTextService.get(.daily_brief_team_to_be_vision_cta)
        ctaButton.setTitle(ctaText, for: .normal)
        ctaButton.corner(radius: Layout.cornerRadius20, borderColor: .white)
        ctaButton.setButtonContentInset(padding: 16)
        toBeVisionLabel.adjustsFontSizeToFitWidth = false
        toBeVisionLabel.lineBreakMode = .byTruncatingTail
    }

    @IBAction func ctaButtonTapped(_ sender: Any) {
        guard let team = team else { return }
        delegate?.showTeamTBV(team)
    }

    override func updateConstraints() {
        super.updateConstraints()
        baseHeaderView?.subtitleTextViewBottomConstraint.constant = 0
    }
}
