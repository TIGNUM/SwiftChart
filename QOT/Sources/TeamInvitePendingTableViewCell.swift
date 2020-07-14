//
//  TeamInvitePendingTableViewCell.swift
//  QOT
//
//  Created by karmic on 14.07.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import UIKit

final class TeamInvitePendingTableViewCell: UITableViewCell, Dequeueable {

    @IBOutlet private weak var teamNameLabel: UILabel!
    @IBOutlet private weak var inviteInfoLabel: UILabel!
    @IBOutlet private weak var declineButton: UIButton!
    @IBOutlet private weak var joinButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        declineButton.corner(radius: 20, borderColor: .accent, borderWidth: 1)
        joinButton.corner(radius: 20, borderColor: .accent, borderWidth: 1)
    }

    func configure(teamName: String,
                   teamColor: String,
                   teamId: String,
                   sender: String,
                   dateOfInvite: String,
                   memberCount: Int) {
        teamNameLabel.text = teamName
        teamNameLabel.textColor = UIColor(hex: teamColor)
        inviteInfoLabel.text = "Invited by " + sender + " at " + dateOfInvite + " | \(memberCount)"
    }
}

extension TeamInvitePendingTableViewCell {
    @IBAction func didTabDecline() {

    }

    @IBAction func didTabJoin() {

    }
}
