//
//  TeamInvitePendingTableViewCell.swift
//  QOT
//
//  Created by karmic on 14.07.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import UIKit

final class TeamInvitePendingTableViewCell: UITableViewCell {

    @IBOutlet private weak var teamNameLabel: UILabel!
    @IBOutlet private weak var inviteInfoLabel: UILabel!
    @IBOutlet private weak var declineButton: UIButton!
    @IBOutlet private weak var joinButton: UIButton!

    func configure(teamName: String,
                   teamColor: UIColor,
                   teamId: String,
                   sender: String,
                   dateOfInvite: String,
                   memberCount: Int) {

    }
}

extension TeamInvitePendingTableViewCell {
    @IBAction func didTabDecline() {

    }

    @IBAction func didTabJoin() {
        
    }
}
