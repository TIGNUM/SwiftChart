//
//  Team.swift
//  QOT
//
//  Created by karmic on 26.06.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

struct Team {
    static let KeyTeamId = "team.key.team.id"
    static let KeyColor = "team.key.team.colot"
    static let KeyInvite = "team.key.invite"

    enum Header: Int, CaseIterable {
        case invite = 0
        case team

        var inviteId: String {
            switch self {
            case .invite: return UUID().uuidString
            case .team: return ""
            }
        }

        var title: String {
            switch self {
            case .invite: return AppTextService.get(.team_invite_header_singular)
            case .team: return ""
            }
        }
    }

    final class Item {
        var invites: [QDMTeamInvitation] = []
        var qdmTeam: QDMTeam = QDMTeam()
        var header: Team.Header
        var title: String
        var teamId: String
        var color: String = ""
        var selected: Bool = false
        var thisUserIsOwner = false
        var batchCount: Int = 0

        /// Init here Team.Item
        init(qdmTeam: QDMTeam) {
            self.header = .team
            self.title = qdmTeam.name ?? ""
            self.teamId = qdmTeam.qotId ?? ""
            self.color = qdmTeam.teamColor ?? ""
            self.thisUserIsOwner = qdmTeam.thisUserIsOwner
            self.qdmTeam = qdmTeam
        }

        /// Team.Item
        init(invites: [QDMTeamInvitation]) {
            self.header = .invite
            self.title = Team.Header.invite.title
            self.teamId = Team.Header.invite.inviteId
            self.invites = invites
            self.batchCount = invites.count
        }
    }
}
