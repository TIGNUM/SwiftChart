//
//  WorkerTeam.swift
//  QOT
//
//  Created by karmic on 02.07.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import Foundation
import qot_dal

protocol WorkerTeam {
    func getTeamConfiguration(_ completion: @escaping (QDMTeamConfiguration?) -> Void)

    func getTeams(_ completion: @escaping ([QDMTeam]) -> Void)

    func getTeamHeaderItems(_ completion: @escaping ([TeamHeader]) -> Void)

    func getTeamMembers(in team: QDMTeam, _ completion: @escaping ([QDMTeamMember]) -> Void)

    func canCreateTeam(_ completion: @escaping (Bool) -> Void)
}

extension WorkerTeam {
    func getTeamConfiguration(_ completion: @escaping (QDMTeamConfiguration?) -> Void) {
        TeamService.main.getTeamConfiguration { (config, error) in
            if let error = error {
                log("Error getTeamConfiguration: \(error.localizedDescription)", level: .error)
                // TODO handle error
            }
            completion(config)
        }
    }

    func getTeams(_ completion: @escaping ([QDMTeam]) -> Void) {
        TeamService.main.getTeams { (teams, _, error) in
            if let error = error {
                log("Error getTeams: \(error.localizedDescription)", level: .error)
                // TODO handle error
            }
            completion(teams ?? [])
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

    func getTeamMembers(in team: QDMTeam, _ completion: @escaping ([QDMTeamMember]) -> Void) {
        TeamService.main.getTeamMembers(in: team) { (members, _, error) in
            if let error = error {
                log("Error getTeamMembers: \(error.localizedDescription)", level: .error)
                // TODO handle error
            }
            completion(members ?? [])
        }
    }

    func canCreateTeam(_ completion: @escaping (Bool) -> Void) {
        getTeamConfiguration { (config) in
            if let config = config {
                self.getTeams { (teams) in
                    completion(teams.count <= config.teamMaxCount)
                }
            } else {
                completion(false)
            }
        }
    }
}
