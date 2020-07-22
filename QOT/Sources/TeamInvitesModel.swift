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
        case pendingInvite
    }

    struct Header {
        let title: String
        let content: String
        let maxTeams: Int

        var noteText: String {
            return String(format: AppTextService.get(.team_invite_content_note), maxTeams)
        }

        func teamCounter(partOfTeams: Int) -> String {
            var text = String(format: AppTextService.get(.team_invite_content_count), partOfTeams)
            if partOfTeams > 1 {
                text = text.replacingOccurrences(of: ".", with: "s.")
            }
            return text
        }
    }

    struct Pending {
        let qdmInvite: QDMTeamInvitation
        var warning: String = ""
        let canJoin: Bool

        init(invite: QDMTeamInvitation, canJoin: Bool, maxTeamCount: Int) {
            self.qdmInvite = invite
            self.canJoin = canJoin
            self.warning = String(format: AppTextService.get(.team_invite_max_capacity), maxTeamCount)
        }
    }
}
