//
//  PollOpenCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 12.10.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class PollOpenCell: BaseDailyBriefCell {

    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var pollLabel: UILabel!
    @IBOutlet private weak var ctaButton: UIButton!
    private var baseHeaderView: QOTBaseHeaderView?
    weak var delegate: DailyBriefViewControllerDelegate?
    var team: QDMTeam?

    override func awakeFromNib() {
        super.awakeFromNib()
        ctaButton.corner(radius: Layout.cornerRadius20, borderColor: .accent40)
        baseHeaderView = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseHeaderView?.addTo(superview: headerView, showSkeleton: true)
        skeletonManager.addSubtitle(pollLabel)
        skeletonManager.addOtherView(ctaButton)
    }

    func configure(model: PollOpenModel?) {
        skeletonManager.hide()
        ctaButton.setTitle(AppTextService.get(.daily_brief_team_open_poll_cta), for: .normal)
        let text = AppTextService.get(.daily_brief_team_open_poll_text).replacingOccurrences(of: "${team_admin}", with: model?.teamAdmin ?? "")
        let title = AppTextService.get(.daily_brief_team_open_poll_title).replacingOccurrences(of: "${team_name}", with: model?.teamName ?? "")
        ThemeText.dailyInsightsTbvAdvice.apply(text, to: pollLabel)
        baseHeaderView?.configure(title: title, subtitle: nil)
        baseHeaderView?.titleLabel.textColor = model?.teamColor
    }

    @IBAction func startPoll(_ sender: Any) {
        guard let team = self.team else { return }
        delegate?.presentToBeVisionPoll(for: team)
    }
}
