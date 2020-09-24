//
//  MyXTeamMembersWorker.swift
//  QOT
//
//  Created by Anais Plancoulaine on 09.07.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

protocol MyXTeamMembersWorker: WorkerTeam {

}

extension MyXTeamMembersWorker {
    var teamMembersText: String {
        return AppTextService.get(.settings_team_settings_team_members).uppercased()
    }

    func getTeamMemberItems(team: QDMTeam, _ completion: @escaping ([TeamMember]) -> Void) {
        var membersList: [TeamMember] = []
        getTeamMembers(in: team) { (members) in
            members.forEach { (member) in
                if member.status != .REMOVED {
                    let status: TeamMember.Status = member.status == .JOINED ? .joined : .pending
                    membersList.append(TeamMember(member: member,
                                                  email: member.email,
                                                  status: status,
                                                  qotId: member.qotId,
                                                  isTeamOwner: member.isTeamOwner,
                                                  wasReinvited: false))
                }
            }
            completion(membersList)
        }
    }
}
