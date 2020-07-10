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
    func canCreateTeam(_ completion: @escaping (Bool) -> Void)

    func getMaxChars(_ completion: @escaping (Int) -> Void)

    func getTeams(_ completion: @escaping ([QDMTeam]) -> Void)

    func getTeamHeaderItems(_ completion: @escaping ([TeamHeader.Item]) -> Void)

    func getTeamMembers(in team: QDMTeam, _ completion: @escaping ([QDMTeamMember]) -> Void)

    func getTeamColors(_ completion: @escaping ([UIColor]) -> Void)

    func getRandomTeamColor(_ completion: @escaping (String) -> Void)

    func createTeam(_ name: String?, _ completion: @escaping (QDMTeam?, Error?) -> Void)

    func sendInvite(_ email: String?, team: QDMTeam?, _ completion: @escaping (QDMTeamMember?, Error?) -> Void)

    func updateTeamName(_ team: QDMTeam?, _ completion: @escaping (QDMTeam?, Error?) -> Void)

    func updateTeamColor(teamId: String, teamColor: String)

    func leaveTeam(team: QDMTeam, _ completion: @escaping (Error?) -> Void)

    func deleteTeam(_ team: QDMTeam, _ completion: @escaping ([QDMTeam]?, Bool, Error?) -> Void)

    func setSelectedTeam(teamId: String, _ completion: @escaping (QDMTeam?) -> Void)
}

extension WorkerTeam {
    func canCreateTeam(_ completion: @escaping (Bool) -> Void) {
         getConfig { (config) in
             if let config = config {
                 self.getTeams { (teams) in
                     completion(teams.count < config.teamMaxCount)
                 }
             } else {
                 completion(false)
             }
         }
     }

    func getMaxChars(_ completion: @escaping (Int) -> Void) {
        getConfig { (config) in
            completion(config?.teamNameMaxLength ?? 0)
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

    func getTeamHeaderItems(_ completion: @escaping ([TeamHeader.Item]) -> Void) {
        getTeams { (teams) in
            self.createTeamHeaderItems(teams: teams) { (headerItems) in
                completion(headerItems)
            }
        }
//        var items = [TeamHeader.Item]()
//        createTeamInvites { (headerInviteItem, teams)  in
//            if case TeamHeader.View.myX = view, !headerInviteItem.teamInvites.isEmpty {
//                items.append(headerInviteItem)
//            }
//            self.createTeamHeaderItems(teams: teams) { (headerItems) in
//                items.append(contentsOf: headerItems)
//                completion(items)
//            }
//        }
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

    func createTeam(_ name: String?, _ completion: @escaping (QDMTeam?, Error?) -> Void) {
        if let name = name {
            getRandomTeamColor { (teamColor) in
                TeamService.main.createTeam(name: name, teamColor: teamColor) { (team, _, error) in
                    if let error = error {
                        log("Error createTeam: \(error.localizedDescription)", level: .error)
                        // TODO handle error
                    }
                    completion(team, error)
                }
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

    func getRandomTeamColor(_ completion: @escaping (String) -> Void) {
        getConfig { (config) in
            guard let colors = config?.availableTeamColors, let random = colors.at(index: colors.randomIndex) else {
                fatalError("Random team color is not available")
            }
            completion(random)
        }
    }

    func getTeamColors(_ completion: @escaping ([UIColor]) -> Void) {
        getConfig { (config) in
            let colors = config?.availableTeamColors.compactMap { (hexColor) -> UIColor in
                return UIColor(hex: hexColor)
            }
            completion(colors ?? [])
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

    func leaveTeam(team: QDMTeam, _ completion: @escaping (Error?) -> Void) {
        getTeamMembers(in: team) { (members) in
          guard let user = members.filter( { $0.me == true } ).first else {
//                completion(error)
                return
            }
            TeamService.main.leaveTeam(teamMember: user, completion)
        }
    }

    func deleteTeam(_ team: QDMTeam, _ completion: @escaping ([QDMTeam]?, Bool, Error?) -> Void) {
        TeamService.main.removeTeam(team, completion)
    }

    func setSelectedTeam(teamId: String, _ completion: @escaping (QDMTeam?) -> Void) {
        getTeams { (teams) in
            let selectedTeam = teams.filter { teamId == $0.qotId }.first
            completion(selectedTeam)
        }
    }

    func getSelectedTeam() {}

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

    func createTeamHeaderItems(teams: [QDMTeam], _ completion: @escaping ([TeamHeader.Item]) -> Void) {
        let teamHeaderItems = teams.filter { $0.teamColor != nil }
            .compactMap { (team) -> TeamHeader.Item in
            return TeamHeader.Item(teamId: team.qotId ?? "",
                                   title: team.name ?? "",
                                   hexColorString: team.teamColor ?? "",
                                   selected: false)
        }
        completion(teamHeaderItems)
    }

//    func createTeamInvites(_ completion: @escaping (TeamHeader, [QDMTeam]) -> Void) {
//        var invites = [TeamInvitation]()
//
//        UserService.main.getUserData { (user) in
//            self.getTeams { (teams) in
//                teams.forEach { (team) in
//                    self.getTeamMembers(in: team) { (members) in
//                        let member = members.filter { $0.me == true }.first
//                        switch member?.status {
//                        case .INVITED?:
//                            invites.append(TeamInvitation(teamId: team.qotId,
//                                                          teamName: team.name,
//                                                          teamColor: team.teamColor,
//                                                          sender: "",
//                                                          date: "",
//                                                          memberCount: 0))
//                        default: break
//                        } // switch
//                    } // getMembers
//                } // teams.forEach
//                completion(TeamHeader(teamInvites: invites), teams)
//            } // getTeams
//        } // getUserData
//    }
}
