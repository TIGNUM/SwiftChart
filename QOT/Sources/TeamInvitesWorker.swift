//
//  TeamInvitesWorker.swift
//  QOT
//
//  Created by karmic on 14.07.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class TeamInvitesWorker: WorkerTeam {
    func getInviteHeader(_ completion: @escaping (TeamInvite.Header) -> Void) {
        getMaxTeamCount { (max) in
            let header = TeamInvite.Header(title: AppTextService.get(.team_invite_header_singular),
                                           content: AppTextService.get(.team_invite_content_info),
                                           maxTeams: max)
            completion(header)
        }
    }

    func getInviteItems(_ completion: @escaping ([TeamInvite.Invitation]) -> Void) {
        getTeamInvitations { (invitations) in
            let items = invitations.compactMap { (invite) -> TeamInvite.Invitation in
                return TeamInvite.Invitation(invite: invite)
            }
            completion(items)
        }
    }
}
