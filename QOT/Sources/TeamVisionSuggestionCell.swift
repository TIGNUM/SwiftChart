//
//  TeamVisionSuggestionCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 31.07.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class TeamVisionSuggestionCell: BaseDailyBriefCell {

    @IBOutlet var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet private weak var button: AnimatedButton!
    @IBOutlet private weak var tbvSentence: UILabel!
    @IBOutlet private weak var adviceText: UILabel!
    private weak var baseHeaderView: QOTBaseHeaderView?
    private var team: QDMTeam?
    weak var delegate: DailyBriefViewControllerDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        button.corner(radius: Layout.cornerRadius20, borderColor: .accent40)
        baseHeaderView = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseHeaderView?.addTo(superview: headerView, showSkeleton: true)
        skeletonManager.addSubtitle(tbvSentence)
        skeletonManager.addSubtitle(adviceText)
        skeletonManager.addOtherView(button)
    }

    func configure(model: TeamVisionSuggestionModel?) {
        skeletonManager.hide()
        let subtitle = AppTextService.get(.daily_brief_team_vision_suggestion_subtitle)
        baseHeaderView?.configure(title: model?.title,
                                  subtitle: subtitle)
        let teamColor = UIColor(hex: model?.team?.teamColor ?? "")
        baseHeaderView?.setColor(dashColor: teamColor, titleColor: teamColor, subtitleColor: nil)
        baseHeaderView?.subtitleTextViewBottomConstraint.constant = 0
        headerHeightConstraint.constant = baseHeaderView?.calculateHeight(for: self.frame.size.width) ?? 0
        let cta = AppTextService.get(.daily_brief_team_vision_suggestion_cta)
        button.setTitle(cta, for: .normal)
        button.setButtonContentInset(padding: 16)
        self.team = model?.team
        ThemeText.dailyInsightsTbvAdvice.apply(model?.adviceText, to: adviceText)
        ThemeText.teamVisionSentence.apply(model?.tbvSentence, to: tbvSentence)
    }
}

private extension TeamVisionSuggestionCell {
    @IBAction func toBeVisionButton(_ sender: Any) {
        guard let team = team else { return }
        delegate?.showTeamTBV(team)
    }
}
