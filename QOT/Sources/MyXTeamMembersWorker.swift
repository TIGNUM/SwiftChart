//
//  MyXTeamMembersWorker.swift
//  QOT
//
//  Created by Anais Plancoulaine on 09.07.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class MyXTeamMembersWorker {

    // MARK: - Init
    init() { /**/ }
}

extension MyXTeamMembersWorker: WorkerTeam {

    var teamMembersText: String {
        return AppTextService.get(.settings_team_settings_team_members)
    }

    func setSelectedTeam(teamId: String, _ completion: @escaping (QDMTeam?) -> Void) {
        TeamService.main.getTeams { (teams, _, _) in
            let selectedTeam = teams?.filter { teamId == $0.qotId }.first
            completion(selectedTeam)
        }
    }

    func teamMemberItems(team: QDMTeam) -> [MyXTeamMemberModel] {
        var membersList: [MyXTeamMemberModel] = []
        getTeamMembers(in: team) { (members) in
            members.forEach {(member) in
                let status: MemberStatus = member.status == .JOINED ? .joined : .pending
                membersList.append(MyXTeamMemberModel(email: member.email, status: status, qotId: member.qotId, isTeamOwner: member.isTeamOwner))
            }
        }
        return membersList
    }
}
