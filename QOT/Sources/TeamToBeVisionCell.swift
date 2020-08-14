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

    private var baseHeaderView: QOTBaseHeaderView?
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var ctaButton: AnimatedButton!
    weak var delegate: DailyBriefViewController?
    @IBOutlet private weak var toBeVisionLabel: UILabel!
    private var team: QDMTeam?

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
        ThemeText.dailyBriefFromTignumTitle.apply(subtitle, to: baseHeaderView?.subtitleTextView)
        ThemeText.bespokeText.apply(model.teamVision, to: toBeVisionLabel)
        let ctaText = AppTextService.get(.daily_brief_team_to_be_vision_cta)
        ctaButton.setTitle(ctaText, for: .normal)
        ctaButton.corner(radius: Layout.cornerRadius20, borderColor: .accent40)
        ctaButton.setButtonContentInset(padding: 16)
        toBeVisionLabel.adjustsFontSizeToFitWidth = false
        toBeVisionLabel.lineBreakMode = .byTruncatingTail
    }

    @IBAction func ctaButtonTapped(_ sender: Any) {
        guard let team = team else { return }
        delegate?.showTBV(team: team)
    }

    override func updateConstraints() {
        super.updateConstraints()
        baseHeaderView?.subtitleTextViewBottomConstraint.constant = 0
    }
}
