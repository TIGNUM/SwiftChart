//
//  TeamInvitesWorker.swift
//  QOT
//
//  Created by karmic on 14.07.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit

final class TeamInvitesWorker {

    // MARK: - Init
    init() { /**/ }

    func getInviteHeader(_ completion: @escaping (TeamInvite.Header) -> Void) {
         let header = TeamInvite.Header(title: "TEAM IVITATION",
                                 content: "TIGNUM X TEAM edition will allow you to stay connected to your team members and support you all to achieve Sustainable High Impact. You are part of 3 team. Note: max 3 teams.")
        completion(header)
    }

    func getInviteItems(_ completion: @escaping ([TeamInvite.Invitation]) -> Void) {
        var items = [TeamInvite.Invitation]()

        items.append(TeamInvite.Invitation(teamId: "123456",
                                           teamName: "Web Team",
                                           teamColor: "#5790DD",
                                           sender: "j.schultz@tignum.com",
                                           dateOfInvite: "05. March",
                                           memberCount: 25,
                                           warningMessage: "You already belong to 3 teams."))

        items.append(TeamInvite.Invitation(teamId: "123457",
                                           teamName: "Design Team",
                                           teamColor: "#E49A9E",
                                           sender: "j.schultz@tignum.com",
                                           dateOfInvite: "27. February",
                                           memberCount: 5,
                                           warningMessage: "You already belong to 3 teams."))

        completion(items)
    }
}
