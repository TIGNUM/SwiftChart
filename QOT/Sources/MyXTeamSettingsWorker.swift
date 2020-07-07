//
//  MyXTeamSettingsWorker.swift
//  QOT
//
//  Created by Anais Plancoulaine on 29.06.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class MyXTeamSettingsWorker {

    func settings() -> MyXTeamSettingsModel {
        return MyXTeamSettingsModel()
    }
}

extension MyXTeamSettingsWorker {

    var teamSettingsText: String {
        return AppTextService.get(.settings_team_settings_title).uppercased()
    }

    func getTeams(_ completion: @escaping ([QDMTeam]) -> Void) {
        TeamService.main.getTeams { (teams, _, error) in
            completion(teams ?? [])
        }
    }

    func deleteTeam(_ team: QDMTeam, _ completion: @escaping ([QDMTeam]?, Bool, Error?) -> Void) {
        TeamService.main.removeTeam(team, completion)
    }

    func leaveTeam(team: QDMTeam, _ completion: @escaping (Error?) -> Void) {
        TeamService.main.getTeamMembers(in: team, { (members, _, error)  in
            guard let user = members?.filter({$0.me == true}).first else {
                completion(error)
                return
            }
            TeamService.main.leaveTeam(teamMember: user, completion)
        })
    }

    func setSelectedTeam(teamId: String, _ completion: @escaping (QDMTeam?) -> Void) {
        TeamService.main.getTeams { (teams, _, _) in
            let selectedTeam = teams?.filter { teamId == $0.qotId }.first
            completion(selectedTeam)
        }
    }

    func getTeamHeaderItems(_ completion: @escaping ([TeamHeader]) -> Void) {
        getTeams { (teams) in
            let teamHeaderItems = teams.filter { $0.teamColor != nil }.compactMap { (team) -> TeamHeader? in
                return TeamHeader(teamId: team.qotId ?? "",
                                  title: team.name ?? "",
                                  hexColorString: team.teamColor ?? "",
                                  sortOrder: 0,
                                  batchCount: 0,
                                  selected: false)
            }
            completion(teamHeaderItems)
        }
    }

    func updateTeamColor(teamId: String, teamColor: String) {
        getTeams { (teams) in
            var team = teams.filter { $0.qotId == teamId }.first
            team?.teamColor = teamColor
            if let team = team {
                TeamService.main.updateTeam(team) { (_, _, error) in
                    if let error = error {
                        log("error update team: \(error.localizedDescription)", level: .error)
                    }
                }
            }
        }
    }
}
