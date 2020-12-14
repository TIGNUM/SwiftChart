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
    @IBOutlet private weak var seePendingButton: AnimatedButton!
    private var baseHeaderView: QOTBaseHeaderView?
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    private var teamInvitation: QDMTeamInvitation?
    weak var delegate: DailyBriefViewControllerDelegate?

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

        let declineCta = AppTextService.get(.daily_brief_team_invitation_decline_cta)
        let pendingCta = AppTextService.get(.daily_brief_team_invitation_see_pending_cta)
        declineButton.setTitle(declineCta, for: .normal)
        seePendingButton.setTitle(pendingCta, for: .normal)
        seePendingButton.isHidden = model?.teamNames?.count == 1
        guard let count = model?.teamNames?.count else { return }
        let whiteAttributes: [NSAttributedString.Key: Any]? = [.font: UIFont.sfProtextSemibold(ofSize: 16), .foregroundColor: UIColor.white]
        let greyAttributes: [NSAttributedString.Key: Any]? = [.font: UIFont.sfProtextRegular(ofSize: 16), .foregroundColor: UIColor.lightGrey]
        ThemeButton.dailyBriefButtons.apply(joinButton)
        if count > 1 {
            joinButton.isHidden = true
            declineButton.isHidden = true
            guard let teamNames = model?.teamNames else { return }
            let attributedString = NSMutableAttributedString(string: text2 + " ", attributes: greyAttributes)
            let firstTeamString = NSMutableAttributedString(string: (teamNames.first ?? "") + " ", attributes: whiteAttributes)
            let andText = AppTextService.get(.daily_brief_team_invitation_and_label) + " "
            let andString = NSMutableAttributedString(string: andText, attributes: greyAttributes)
            let otherTeamsText = AppTextService.get(.daily_brief_team_invitation_other_teams_label)
            let teamCount = String(teamNames.count - 1) + " "
            let otherTeamsString = NSMutableAttributedString(string: teamCount + otherTeamsText, attributes: whiteAttributes)
            attributedString.append(firstTeamString)
            attributedString.append(andString)
            attributedString.append(otherTeamsString)
            invitationLabel.attributedText = attributedString
        } else {
            self.teamInvitation = model?.teamInvitations?.first
            guard let teamOwner = model?.teamOwner else { return }
            guard let teamNames = model?.teamNames else { return }
            let attributedString = NSMutableAttributedString(string: teamOwner + " ", attributes: whiteAttributes)
            let teamNameString = NSMutableAttributedString(string: (teamNames.first ?? "" + " "), attributes: whiteAttributes)
            let textString =  NSMutableAttributedString(string: text1 + " ", attributes: greyAttributes)
            let belongingTextString = NSMutableAttributedString(string: "\n" + belongingText, attributes: greyAttributes)
            attributedString.append(textString)
            attributedString.append(teamNameString)
            attributedString.append(belongingTextString)
            invitationLabel.attributedText = attributedString
        }
    }

    @IBAction func didTapDecline(_ sender: Any) {
        if let invitation = teamInvitation {
            trackUserEvent(.DECLINE_TEAM_INVITATION, value: invitation.team?.remoteID ?? 0, action: .TAP)
            delegate?.didSelectDeclineTeamInvite(invitation: invitation)
            delegate?.showBanner(message: AppTextService.get(.team_invite_banner_message_decline))
        }
    }

    @IBAction func didTapJoin(_ sender: Any) {
        if let invitation = teamInvitation {
            trackUserEvent(.ACCEPT_TEAM_INVITATION, value: invitation.team?.remoteID ?? 0, action: .TAP)
            delegate?.didSelectJoinTeamInvite(invitation: invitation)
            delegate?.showBanner(message: AppTextService.get(.team_invite_banner_message_join))
        }
    }

    @IBAction func didTapPending(_ sender: Any) {
        delegate?.presentTeamPendingInvites()
    }
}
