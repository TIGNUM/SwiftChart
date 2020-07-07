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
    func getTeams(_ completion: @escaping ([QDMTeam]) -> Void)

    func getTeamHeaderItems(_ completion: @escaping ([TeamHeader]) -> Void)

    func getTeamMembers(in team: QDMTeam, _ completion: @escaping ([QDMTeamMember]) -> Void)

    func canCreateTeam(_ completion: @escaping (Bool) -> Void)

    func teamCreate(_ name: String?, _ completion: @escaping (QDMTeam?, Error?) -> Void)

    func sendInvite(_ email: String?, team: QDMTeam?, _ completion: @escaping (QDMTeamMember?, Error?) -> Void)

    func updateTeamName(_ team: QDMTeam?, _ completion: @escaping (QDMTeam?, Error?) -> Void)

    func getMaxChars(_ completion: @escaping (Int) -> Void)
}

extension WorkerTeam {
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

    func teamCreate(_ name: String?, _ completion: @escaping (QDMTeam?, Error?) -> Void) {
        if let name = name {
            TeamService.main.createTeam(name: name, teamColor: UIColor.randomTeamColor.toHexString) { (team, _, error) in
                if let error = error {
                    log("Error createTeam: \(error.localizedDescription)", level: .error)
                    // TODO handle error
                }
                completion(team, error)
            }
        } else {
            completion(nil, nil)
        }
    }

    func sendInvite(_ email: String?, team: QDMTeam?, _ completion: @escaping (QDMTeamMember?, Error?) -> Void) {
        if let team = team, let email = email {
            TeamService.main.inviteTeamMember(email: email, in: team) { (member, _, error) in
                if let error = error {
                    log("Error inviteTeamMember: \(error.localizedDescription)", level: .error)
                    // TODO handle error
                }
                completion(member, error)
            }
        } else {
            completion(nil, nil)
        }
    }

    func updateTeamName(_ team: QDMTeam?, _ completion: @escaping (QDMTeam?, Error?) -> Void) {
        guard let team = team else { return }
        TeamService.main.updateTeam(team) { (team, _, error) in
            if let error = error {
                log("Error updateTeam: \(error.localizedDescription)", level: .error)
                // TODO handle error
            }
            completion(team, error)
            NotificationCenter.default.post(name: .didEditTeam, object: team?.qotId)
        }
    }

    func getMaxChars(_ completion: @escaping (Int) -> Void) {
        getConfig { (config) in
            completion(config?.teamNameMaxLength ?? 0)
        }
    }

    func canCreateTeam(_ completion: @escaping (Bool) -> Void) {
         getConfig { (config) in
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

// MARK: - Private
private extension WorkerTeam {
    func getConfig(_ completion: @escaping (QDMTeamConfiguration?) -> Void) {
        TeamService.main.getTeamConfiguration { (config, error) in
            if let error = error {
                log("Error getTeamConfiguration: \(error.localizedDescription)", level: .error)
                // TODO handle error
            }
            completion(config)
        }
    }
}
