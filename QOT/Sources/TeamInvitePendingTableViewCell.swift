//
//  TeamInvitePendingTableViewCell.swift
//  QOT
//
//  Created by karmic on 14.07.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class TeamInvitePendingTableViewCell: UITableViewCell, Dequeueable {

    @IBOutlet private weak var teamNameLabel: UILabel!
    @IBOutlet private weak var inviteInfoLabel: UILabel!
    @IBOutlet private weak var declineButton: UIButton!
    @IBOutlet private weak var joinButton: UIButton!
    private var teamId: String = ""

    override func awakeFromNib() {
        super.awakeFromNib()
        declineButton.corner(radius: 20, borderColor: .accent, borderWidth: 1)
        joinButton.corner(radius: 20, borderColor: .accent, borderWidth: 1)
        declineButton.setTitle(AppTextService.get(.team_invite_cta_decline), for: .normal)
        joinButton.setTitle(AppTextService.get(.team_invite_cta_join), for: .normal)
    }

    func configure(teamName: String,
                   teamColor: String,
                   teamId: String,
                   sender: String,
                   dateOfInvite: String,
                   memberCount: Int) {
        self.teamId = teamId
        teamNameLabel.text = teamName
        teamNameLabel.textColor = UIColor(hex: teamColor)
        inviteInfoLabel.text = "Invited by " + sender + " at " + dateOfInvite + " | \(memberCount)"
    }
}

extension TeamInvitePendingTableViewCell {
    @IBAction func didTabDecline() {
        NotificationCenter.default.post(name: .didSelectTeamInviteDecline, object: teamId)
    }

    @IBAction func didTabJoin() {
        NotificationCenter.default.post(name: .didSelectTeamInviteJoin, object: teamId)
    }
}
