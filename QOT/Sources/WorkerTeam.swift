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

    func getMaxTeamCount(_ completion: @escaping (Int) -> Void)

    func getTeams(_ completion: @escaping ([QDMTeam]) -> Void)

    func getTeamHeaderItems(showInvites: Bool, _ completion: @escaping ([Team.Item]) -> Void)

    func getTeamMembers(in team: QDMTeam, _ completion: @escaping ([QDMTeamMember]) -> Void)

    func getTeamColors(_ completion: @escaping ([String]) -> Void)

    func getRandomTeamColor(_ completion: @escaping (String) -> Void)

    func createTeam(_ name: String?, _ completion: @escaping (QDMTeam?, Error?) -> Void)

    func sendInvite(_ email: String?, team: QDMTeam?, _ completion: @escaping (QDMTeamMember?, Error?) -> Void)

    func updateTeamName(_ team: QDMTeam?, _ completion: @escaping (QDMTeam?, Error?) -> Void)

    func updateTeamColor(teamId: String, teamColor: String)

    func leaveTeam(team: QDMTeam, _ completion: @escaping (Error?) -> Void)

    func deleteTeam(_ team: QDMTeam, _ completion: @escaping ([QDMTeam]?, Bool, Error?) -> Void)

    func getSelectedTeam(teamId: String?, _ completion: @escaping (QDMTeam?) -> Void)

    func joinTeamInvite(_ invitation: QDMTeamInvitation, _ completion: @escaping ([QDMTeam]) -> Void)

    func declineTeamInvite(_ invitation: QDMTeamInvitation, _ completion: @escaping ([QDMTeam]) -> Void)

    func getTeamInvitations(_ completion: @escaping ([QDMTeamInvitation]) -> Void)

    func removeMember(member: QDMTeamMember, _ completion: @escaping () -> Void)

    func reInviteMember(member: QDMTeamMember, _ completion: @escaping (QDMTeamMember?) -> Void)

    func getTeamToBeVision(for team: QDMTeam, _ completion: @escaping (QDMTeamToBeVision?) -> Void)

    func updateTeamToBeVision(_ new: QDMTeamToBeVision, team: QDMTeam, _ completion: @escaping (QDMTeamToBeVision?) -> Void)
}

extension WorkerTeam {
    func canCreateTeam(_ completion: @escaping (Bool) -> Void) {
        getMaxTeamCount { (max) in
            self.getTeams { (teams) in
                completion(teams.count < max)
            }
        }
    }

    func getMaxTeamCount(_ completion: @escaping (Int) -> Void) {
        getConfig { (config) in
            completion(config?.teamMaxCount ?? 0)
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

    func getTeamHeaderItems(showInvites: Bool, _ completion: @escaping ([Team.Item]) -> Void) {
        getTeams { (teams) in
            if showInvites {
                self.getTeamInvitations { (invites) in
                    self.createTeamHeaderItems(invites: invites, teams: teams) { (headerItems) in
                        completion(headerItems)
                    }
                }
            } else {
                self.createTeamHeaderItems(invites: [], teams: teams) { (headerItems) in
                    completion(headerItems)
                }
            }
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

    func getTeamColors(_ completion: @escaping ([String]) -> Void) {
        getConfig { (config) in
            completion(config?.availableTeamColors ?? [])
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
            NotificationCenter.default.post(name: .didEditTeamName,
                                            object: nil,
                                            userInfo: [team?.qotId: team?.name ?? ""])
        }
    }

    func leaveTeam(team: QDMTeam, _ completion: @escaping (Error?) -> Void) {
        getTeamMembers(in: team) { (members) in
            guard let user = members.filter({$0.me == true}).first else {
                //                completion(error)
                return
            }
            TeamService.main.leaveTeam(teamMember: user, completion)
        }
    }

    func deleteTeam(_ team: QDMTeam, _ completion: @escaping ([QDMTeam]?, Bool, Error?) -> Void) {
        TeamService.main.removeTeam(team, completion)
    }

    func getSelectedTeam(teamId: String?, _ completion: @escaping (QDMTeam?) -> Void) {
        if let teamId = teamId {
            getTeams { (teams) in
                let selectedTeam = teams.filter { teamId == $0.qotId }.first
                completion(selectedTeam)
            }
        } else {
            completion(nil)
        }
    }

    func getTeamInvitations(_ completion: @escaping ([QDMTeamInvitation]) -> Void) {
        TeamService.main.getTeamInvitations { (invitations, error) in
            if let error = error {
                log("Error getTeamInvitations: \(error.localizedDescription)", level: .error)
                // TODO handle error
            }
            completion(invitations ?? [])
        }
    }

    func joinTeamInvite(_ invitation: QDMTeamInvitation, _ completion: @escaping ([QDMTeam]) -> Void) {
        TeamService.main.acceptTeamInvitation(invitation) { (teams, error) in
            if let error = error {
                log("Error acceptTeamInvitation: \(error.localizedDescription)", level: .error)
                // TODO handle error
            }
            completion(teams ?? [])
        }
    }

    func declineTeamInvite(_ invitation: QDMTeamInvitation, _ completion: @escaping ([QDMTeam]) -> Void) {
        TeamService.main.rejectTeamInvitation(invitation) { (teams, error) in
            if let error = error {
                log("Error rejectTeamInvitation: \(error.localizedDescription)", level: .error)
                // TODO handle error
            }
            completion(teams ?? [])
        }
    }

    func removeMember(member: QDMTeamMember, _ completion: @escaping () -> Void) {
        TeamService.main.removeTeamMember(member) { (error) in
            if let error = error {
                log("Error removeTeamMember: \(error.localizedDescription)", level: .error)
                // TODO handle error
            }
            completion()
        }
    }

    func reInviteMember(member: QDMTeamMember, _ completion: @escaping (QDMTeamMember?) -> Void) {
        TeamService.main.reinviteTeamMember(member) { (member, _, error) in
            if let error = error {
                log("Error removeTeamMember: \(error.localizedDescription)", level: .error)
                // TODO handle error
            }
            completion(member)
        }
    }

    func getTeamToBeVision(for team: QDMTeam, _ completion: @escaping (QDMTeamToBeVision?) -> Void) {
        TeamService.main.getTeamToBevision(for: team) { (teamVision, _, error) in
            if let error = error {
                log("Error getTeamToBevision: \(error.localizedDescription)", level: .error)
                // TODO handle error
            }
            completion(teamVision)
        }
    }

    func updateTeamToBeVision(_ new: QDMTeamToBeVision, team: QDMTeam, _ completion: @escaping (QDMTeamToBeVision?) -> Void) {
        TeamService.main.updateTeamToBevision(vision: new) { (vision, error)  in
            if let error = error {
                log("Error updateTeamToBevision: \(error.localizedDescription)", level: .error)
                // TODO handle error
            }
            completion(vision)
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

    func createTeamHeaderItems(invites: [QDMTeamInvitation],
                               teams: [QDMTeam],
                               _ completion: @escaping ([Team.Item]) -> Void) {
        var teamHeaderItems = [Team.Item]()
        if !invites.isEmpty {
            teamHeaderItems.append(Team.Item(invites: invites))
        }
        teamHeaderItems.append(contentsOf: teams.compactMap { (team) -> Team.Item in
            return Team.Item(qdmTeam: team)
        })
        completion(teamHeaderItems)
    }
}
