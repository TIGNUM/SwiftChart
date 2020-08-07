//
//  TeamInvitationCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 03.08.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class TeamInvitationCell: BaseDailyBriefCell {

    @IBOutlet weak var headerView: UIView!
    @IBOutlet private weak var invitationLabel: UILabel!
    @IBOutlet private weak var declineButton: AnimatedButton!
    @IBOutlet private weak var joinButton: AnimatedButton!
    @IBOutlet private weak var seePendingButton: UIButton!
    private var baseHeaderView: QOTBaseHeaderView?
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        joinButton.corner(radius: Layout.cornerRadius20, borderColor: .accent40)
        declineButton.corner(radius: Layout.cornerRadius20, borderColor: .accent40)
        seePendingButton.corner(radius: Layout.cornerRadius20, borderColor: .accent40)
        baseHeaderView = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseHeaderView?.addTo(superview: headerView, showSkeleton: true)
        skeletonManager.addSubtitle(invitationLabel)
        skeletonManager.addOtherView(declineButton)
        skeletonManager.addOtherView(joinButton)
        skeletonManager.addOtherView(seePendingButton)
    }

    func configure(model: TeamInvitationModel?) {
        skeletonManager.hide()
        let joinCta = AppTextService.get(.daily_brief_team_invitation_join_cta)
        let title = AppTextService.get(.daily_brief_team_invitation_title)
        baseHeaderView?.configure(title: title,
                                  subtitle: nil)
        joinButton.setTitle(joinCta, for: .normal)
        let text1 = AppTextService.get(.daily_brief_team_invitation_one_team_statement)
        let belongingText = AppTextService.get(.daily_brief_team_invitation_belonging_sentence)
        let text2 = AppTextService.get(.daily_brief_team_invitation_several_teams_statement)

        joinButton.setButtonContentInset(padding: 16)
        let declineCta = AppTextService.get(.daily_brief_team_invitation_decline_cta)
        let pendingCta = AppTextService.get(.daily_brief_team_invitation_see_pending_cta)
        declineButton.setTitle(declineCta, for: .normal)
        declineButton.setButtonContentInset(padding: 16)
        seePendingButton.setTitle(pendingCta, for: .normal)
        seePendingButton.setButtonContentInset(padding: 16)
        seePendingButton.isHidden = model?.teamNames?.count == 1
        guard let count = model?.teamNames?.count else { return }
        let sandAttributes: [NSAttributedString.Key: Any]? = [.font: UIFont.sfProtextSemibold(ofSize: 16), .foregroundColor: UIColor.sand]
        let sand70Attributes: [NSAttributedString.Key: Any]? = [.font: UIFont.sfProtextRegular(ofSize: 16), .foregroundColor: UIColor.sand70]
        if count > 1 {
            joinButton.isHidden = true
            declineButton.isHidden = true
            guard let teamNames = model?.teamNames else { return }
            let attributedString = NSMutableAttributedString(string: text2 + " ", attributes: sand70Attributes)
            let firstTeamString = NSMutableAttributedString(string: (teamNames.first ?? "") + " ", attributes: sandAttributes)
            let andText = AppTextService.get(.daily_brief_team_invitation_and_label) + " "
            let andString = NSMutableAttributedString(string: andText, attributes: sand70Attributes)
            let otherTeamsText = AppTextService.get(.daily_brief_team_invitation_other_teams_label)
            let teamCount = String(teamNames.count - 1) + " "
            let otherTeamsString = NSMutableAttributedString(string: teamCount + otherTeamsText, attributes: sandAttributes)
            attributedString.append(firstTeamString)
            attributedString.append(andString)
            attributedString.append(otherTeamsString)
            invitationLabel.attributedText = attributedString
        } else {
            guard let teamOwner = model?.teamOwner else { return }
            guard let teamNames = model?.teamNames else { return }
            let attributedString = NSMutableAttributedString(string: teamOwner + " ", attributes: sandAttributes)
            let teamNameString = NSMutableAttributedString(string: (teamNames.first ?? "" + " "), attributes: sandAttributes)
            let textString =  NSMutableAttributedString(string: text1 + " ", attributes: sand70Attributes)
            let belongingTextString = NSMutableAttributedString(string: "\n" + belongingText, attributes: sand70Attributes)
            attributedString.append(textString)
            attributedString.append(teamNameString)
            attributedString.append(belongingTextString)
            invitationLabel.attributedText = attributedString
        }
    }

//    @IBAction func didTabDecline() {
//          NotificationCenter.default.post(name: .didSelectTeamInviteDecline, object: pendingInvite?.qdmInvite)
//      }
//
//      @IBAction func didTabJoin() {
//          NotificationCenter.default.post(name: .didSelectTeamInviteJoin, object: pendingInvite?.qdmInvite)
//      }
}
