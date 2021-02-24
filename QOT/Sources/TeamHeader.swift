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
        case myX = 0
        case invite
        case team

        var inviteId: String {
            switch self {
            case .myX: return "team.key.myX.default"
            case .invite: return UUID().uuidString
            case .team: return String.empty
            }
        }

        var title: String {
            switch self {
            case .myX: return AppTextService.get(.my_qot_section_header_title).capitalized
            case .invite: return AppTextService.get(.team_invite_header_singular)
            case .team: return String.empty
            }
        }
    }

    final class Item {
        var invites: [QDMTeamInvitation] = []
        var qdmTeam: QDMTeam?
        var header: Team.Header
        var title: String
        var teamId: String
        var color: String = String.empty
        var thisUserIsOwner = false
        var batchCount: Int = 0

        /// Init here Team.Item
        init(qdmTeam: QDMTeam) {
            self.header = .team
            self.title = qdmTeam.name ?? String.empty
            self.teamId = qdmTeam.qotId ?? String.empty
            self.color = qdmTeam.teamColor ?? String.empty
            self.thisUserIsOwner = qdmTeam.thisUserIsOwner
            self.qdmTeam = qdmTeam
        }

        /// Team.Item
        init(invites: [QDMTeamInvitation], _ newItemCount: Int? = 0) {
            self.header = .invite
            self.title = Team.Header.invite.title
            self.teamId = Team.Header.invite.inviteId
            self.invites = invites
            self.batchCount = newItemCount ?? 0
        }

        init(myX: Team.Header) {
            guard myX == Team.Header.myX else {
                fatalError("This header item is not myX.")
            }
            self.header = myX
            self.title = myX.title
            self.teamId = myX.inviteId
            self.color = UIColor.accent.toHexString
        }

        var isSelected: Bool {
            return teamId == HorizontalHeaderView.selectedTeamId
        }
    }
}
