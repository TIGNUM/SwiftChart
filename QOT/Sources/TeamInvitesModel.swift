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

    enum BannerType {
        case join
        case decline

        var message: String {
            switch self {
            case .join: return AppTextService.get(.team_invite_banner_message_join)
            case .decline: return AppTextService.get(.team_invite_banner_message_decline)
            }
        }
    }

    class Header {
        let title: String = AppTextService.get(.team_invite_header_singular) + "S"
        private var maxTeams: Int
        private var partOfTeams: Int
        private var showOnlyContent: Bool

        init(maxTeams: Int, partOfTeams: Int) {
            self.maxTeams = maxTeams
            self.partOfTeams = partOfTeams
            self.showOnlyContent = partOfTeams == maxTeams || partOfTeams == .zero
        }

        var noteText: String? {
            if showOnlyContent {
                return nil
            }
            return String(format: AppTextService.get(.team_invite_content_note), maxTeams)
        }

        var teamCounter: String? {
            if showOnlyContent {
                return nil
            }
            var text = String(format: AppTextService.get(.team_invite_content_count), partOfTeams)
            if partOfTeams != 1 {
                text = text.replacingOccurrences(of: ".", with: "s.")
            }
            return text
        }

        var content: String {
            if partOfTeams < maxTeams {
                return AppTextService.get(.team_invite_content_info)
            }
            return String(format: AppTextService.get(.team_invite_content_info_reached_max), maxTeams)
        }
    }

    struct Pending {
        let qdmInvite: QDMTeamInvitation
        var warning: String = String.empty
        let canJoin: Bool

        init(invite: QDMTeamInvitation, canJoin: Bool, maxTeamCount: Int) {
            self.qdmInvite = invite
            self.canJoin = canJoin
            self.warning = String(format: AppTextService.get(.team_invite_max_capacity), maxTeamCount)
        }
    }
}
