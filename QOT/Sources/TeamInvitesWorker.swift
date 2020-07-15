//
//  TeamInvitesWorker.swift
//  QOT
//
//  Created by karmic on 14.07.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit

final class TeamInvitesWorker: WorkerTeam {

    // MARK: - Init
    init() { /**/ }

    func getInviteHeader(_ completion: @escaping (TeamInvite.Header) -> Void) {
         let header = TeamInvite.Header(title: "TEAM IVITATION",
                                 content: "TIGNUM X TEAM edition will allow you to stay connected to your team members and support you all to achieve Sustainable High Impact. You are part of 3 team. Note: max 3 teams.")
        completion(header)
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
