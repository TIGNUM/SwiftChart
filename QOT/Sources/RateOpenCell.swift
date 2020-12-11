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
    private var team: QDMTeam?

    override func awakeFromNib() {
        super.awakeFromNib()
        ctaButton.corner(radius: Layout.cornerRadius20, borderColor: .accent40)
        baseHeaderView = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseHeaderView?.addTo(superview: headerView, showSkeleton: true)
        skeletonManager.addSubtitle(rateLabel)
        skeletonManager.addOtherView(ctaButton)
    }

    @IBAction func startRating(_ sender: Any) {
        guard let team = team else { return }
        delegate?.presentToBeVisionRate(for: team)
    }

    func configure(model: RateOpenModel?) {
        skeletonManager.hide()
        ctaButton.setTitle(AppTextService.get(.daily_brief_rate_open_cta), for: .normal)
        let whiteAttributes: [NSAttributedString.Key: Any]? = [.font: UIFont.sfProtextSemibold(ofSize: 16), .foregroundColor: UIColor.white]
        let greyAttributes: [NSAttributedString.Key: Any]? = [.font: UIFont.sfProtextRegular(ofSize: 16), .foregroundColor: UIColor.lightGrey]
        let attributedString = NSMutableAttributedString(string: (model?.ownerEmail ?? "") + " ", attributes: whiteAttributes)
        let text = NSMutableAttributedString(string: AppTextService.get(.daily_brief_rate_open_text), attributes: greyAttributes)
        attributedString.append(text)
        rateLabel.attributedText = attributedString
        let teamName = model?.team?.name?.uppercased()
        let title = AppTextService.get(.daily_brief_vision_rating_title).replacingOccurrences(of: "${TEAM_NAME}", with: teamName ?? "")
        baseHeaderView?.configure(title: title, subtitle: nil)
        let teamColor = UIColor(hex: model?.team?.teamColor ?? "")
        self.team = model?.team
        baseHeaderView?.setColor(dashColor: teamColor, titleColor: teamColor, subtitleColor: nil)
    }
}
