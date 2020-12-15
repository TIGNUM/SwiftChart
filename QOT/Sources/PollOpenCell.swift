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
        let whiteAttributes: [NSAttributedString.Key: Any]? = [.font: UIFont.sfProtextSemibold(ofSize: 16), .foregroundColor: UIColor.white]
        let greyAttributes: [NSAttributedString.Key: Any]? = [.font: UIFont.sfProtextRegular(ofSize: 16), .foregroundColor: UIColor.lightGrey]
        let attributedString = NSMutableAttributedString(string: (model?.teamAdmin ?? "") + " ", attributes: whiteAttributes)
        let text = NSMutableAttributedString(string: AppTextService.get(.daily_brief_team_open_poll_text), attributes: greyAttributes)
        attributedString.append(text)
        pollLabel.attributedText = attributedString
        let title = AppTextService.get(.daily_brief_team_open_poll_title).replacingOccurrences(of: "${team_name}", with: model?.team?.name ?? "").uppercased()
        baseHeaderView?.configure(title: title, subtitle: nil)
        self.team = model?.team
        let teamColor = UIColor(hex: model?.team?.teamColor ?? "")
        baseHeaderView?.setColor(dashColor: teamColor, titleColor: teamColor, subtitleColor: nil)
    }

    @IBAction func startPoll(_ sender: Any) {
        guard let team = self.team else { return }
        delegate?.presentToBeVisionPoll(for: team)
    }
}
