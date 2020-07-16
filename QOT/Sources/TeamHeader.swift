//
//  Team.swift
//  QOT
//
//  Created by karmic on 26.06.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import UIKit
import DifferenceKit
import qot_dal

struct Team {
    static let KeyTeamId = "team.key.team.id"
    static let KeyColor = "team.key.team.colot"
    static let keyInvite = "team.key.invite"

    enum Header: Int, CaseIterable, Differentiable {
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

    final class Item: Differentiable {
        typealias DifferenceIdentifier = String

        var invites: [QDMTeamInvitation] = []
        var header: Team.Header
        var title: String
        var teamId: String
        var color: String = ""
        var selected: Bool = false
        var batchCount: Int = 0

        /// Init here Team.Item
        init(title: String, teamId: String, color: String) {
            self.header = .team
            self.title = title
            self.teamId = teamId
            self.color = color
        }

        /// Team.Item
        init(invites: [QDMTeamInvitation]) {
            self.header = .invite
            self.title = Team.Header.invite.title
            self.teamId = Team.Header.invite.inviteId
            self.invites = invites
        }

        /// Invite.Item
        var differenceIdentifier: DifferenceIdentifier {
            return teamId
        }

        func isContentEqual(to source: Item) -> Bool {
            return title == source.title &&
                color == source.color &&
                selected == source.selected &&
                batchCount == source.batchCount
        }
    }
}
