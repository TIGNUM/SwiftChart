//
//  TeamInvitesModel.swift
//  QOT
//
//  Created by karmic on 14.07.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

struct TeamInvite {
    enum Section: Int, CaseIterable {
        case header = 0
        case invite
    }

    struct Header {
        let title: String
        let content: String
    }

    struct Invitation {
        let invite: QDMTeamInvitation
        let teamQotId: String
        let teamName: String
        let teamColor: String
        let sender: String
        let dateOfInvite: Date
        let memberCount: Int
        let warningMessage: String = AppTextService.get(.team_invite_max_capacity)

        init(invite: QDMTeamInvitation) {
            self.invite = invite
            self.teamQotId = invite.team?.qotId ?? ""
            self.teamName = invite.team?.name ?? ""
            self.teamColor = invite.team?.teamColor ?? ""
            self.sender = invite.sender ?? ""
            self.dateOfInvite = invite.invitedDate ?? Date()
            self.memberCount = 23
        }

        func canJoin(maxTeams: Int, partOfTeams: Int) -> Bool {
            return partOfTeams < maxTeams
        }
    }
}
