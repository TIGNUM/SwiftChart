//
//  WorkerTeam.swift
//  QOT
//
//  Created by karmic on 02.07.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import Foundation
import qot_dal

protocol WorkerTeam: class {

    func getMaxTeamMemberCount(_ completion: @escaping (Int) -> Void)

    func canCreateTeam(_ completion: @escaping (Bool) -> Void)

    func getMaxChars(_ completion: @escaping (Int) -> Void)

    func getMaxTeamCount(_ completion: @escaping (Int) -> Void)

    func getTeams(_ completion: @escaping ([QDMTeam]) -> Void)

    func getTeamHeaderItems(showNewRedDot: Bool,
                            _ completion: @escaping ([Team.Item]) -> Void)

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

    func getTeamToBeVisionShareData(_ teamVision: QDMTeamToBeVision,
                                    _ completion: @escaping (QDMToBeVisionShare?, Error?) -> Void)

    func getCurrentTeamToBeVisionPoll(for team: QDMTeam,
                                      _ completion: @escaping (QDMTeamToBeVisionPoll?) -> Void)

    func openNewTeamToBeVisionPoll(for team: QDMTeam,
                                   sendPushNotification: Bool,
                                   _ completion: @escaping (QDMTeamToBeVisionPoll?) -> Void)

    func closeTeamToBeVisionPoll(_ poll: QDMTeamToBeVisionPoll,
                                 _ completion: @escaping (QDMTeamToBeVisionPoll?) -> Void)

    func getTeamTBVPollRemainingDays(_ remainingDays: Int) -> NSAttributedString

    func dateString(for day: Int) -> String

    func voteTeamToBeVisionPoll(_ poll: QDMTeamToBeVisionPoll,
                                question: QDMQuestion,
                                votes: [QDMAnswer],
                                _ completion: @escaping (QDMTeamToBeVisionPoll?) -> Void)

    func voteTeamToBeVisionTrackerPoll(_ votes: [QDMTeamToBeVisionTrackerVote],
                                       _ completion: @escaping (QDMTeamToBeVisionTrackerPoll?) -> Void)

    func openNewTeamToBeVisionTrackerPoll(for team: QDMTeam,
                                          sendPushNotification: Bool,
                                          _ completion: @escaping (QDMTeamToBeVisionTrackerPoll?) -> Void)

    func hasOpenRatingPoll(for team: QDMTeam, _ completion: @escaping (Bool) -> Void)

    func getCurrentRatingPoll(for team: QDMTeam, _ completion: @escaping (QDMTeamToBeVisionTrackerPoll?) -> Void)

    func closeRatingPoll(for team: QDMTeam, _ completion: @escaping () -> Void)

    func getLatestClosedPolls(for team: QDMTeam, _ completion: @escaping ([QDMTeamToBeVisionTrackerPoll]?) -> Void)

    func getRatingReport(_ completion: @escaping (QDMToBeVisionRatingReport?) -> Void)

    func hasOpenGeneratorPoll(for team: QDMTeam, _ completion: @escaping (Bool) -> Void)
}

extension WorkerTeam {

    func getMaxTeamMemberCount(_ completion: @escaping (Int) -> Void) {
        getConfig { (config) in
            completion(config?.teamMaxMemberCount ?? .zero)
        }
    }

    func canCreateTeam(_ completion: @escaping (Bool) -> Void) {
        getMaxTeamCount { (max) in
            self.getTeams { (teams) in
                completion(teams.count < max)
            }
        }
    }

    func getMaxTeamCount(_ completion: @escaping (Int) -> Void) {
        getConfig { (config) in
            completion(config?.teamMaxCount ?? .zero)
        }
    }

    func getMaxChars(_ completion: @escaping (Int) -> Void) {
        getConfig { (config) in
            completion(config?.teamNameMaxLength ?? .zero)
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

    func getTeamHeaderItems(showNewRedDot: Bool,
                            _ completion: @escaping ([Team.Item]) -> Void) {
        getTeams { (teams) in
            if showNewRedDot {
                self.getTeamInvitations { (invites) in
                    self.createTeamHeaderItems(invites: invites, isMyX: true, teams: teams) { (headerItems) in
                        completion(headerItems)
                    }
                }
            } else {
                self.createTeamHeaderItems(invites: [], isMyX: false, teams: teams) { (headerItems) in
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

    func getTeamToBeVisionShareData(_ teamVision: QDMTeamToBeVision,
                                    _ completion: @escaping (QDMToBeVisionShare?, Error?) -> Void) {
        TeamService.main.getTeamToBeVisionShareData(for: teamVision, completion)
    }

    func hasOpenRatingPoll(for team: QDMTeam, _ completion: @escaping (Bool) -> Void) {
        TeamService.main.currentTeamToBeVisionTrackerPoll(for: team) { (currentTrackingPoll, _, error) in
            if let error = error {
                log("Error currentTeamToBeVisionTrackerPoll: \(error.localizedDescription)", level: .error)
                // TODO handle error
            }
            completion(currentTrackingPoll != nil)
        }
    }

    func hasOpenGeneratorPoll(for team: QDMTeam, _ completion: @escaping (Bool) -> Void) {
        TeamService.main.getCurrentTeamToBeVisionPoll(for: team) { (currentPoll, _, error) in
            if let error = error {
                log("Error currentTeamToBeVisionPoll: \(error.localizedDescription)", level: .error)
                // TODO handle error
            }
            completion(currentPoll != nil)
        }
    }

    func getCurrentRatingPoll(for team: QDMTeam, _ completion: @escaping (QDMTeamToBeVisionTrackerPoll?) -> Void) {
        TeamService.main.currentTeamToBeVisionTrackerPoll(for: team) { (currentTrackingPoll, _, error) in
            if let error = error {
                log("Error currentTeamToBeVisionTrackerPoll: \(error.localizedDescription)", level: .error)
                // TODO handle error
            }
            completion(currentTrackingPoll)
        }
    }

    func closeRatingPoll(for team: QDMTeam, _ completion: @escaping () -> Void) {
        getCurrentRatingPoll(for: team) { (currentTrackingPoll) in
            guard let currentPoll = currentTrackingPoll else { return }
            TeamService.main.closeTeamToBeVisionTrackerPoll(currentPoll) { (_, _, error) in
                if let error = error {
                    log("Error closeTeamToBeVisionTrackerPoll: \(error.localizedDescription)", level: .error)
                    // TODO handle error
                }
                completion()
            }
        }
    }

    func getLatestClosedPolls(for team: QDMTeam, _ completion: @escaping ([QDMTeamToBeVisionTrackerPoll]?) -> Void) {
        TeamService.main.allTeamToBeVisionTrackerPoll(for: team) { (allPolls, _, error) in
            if let error = error {
                log("Error allTeamToBeVisionTrackerPol: \(error.localizedDescription)", level: .error)
                // TODO handle error
            }
            var filteredPolls = self.getSortedClosedPollsWithRatings(allPolls: allPolls)
            filteredPolls.sort(by: { $0.createdAt ?? Date() < $1.createdAt ?? Date() })
            var lastPolls: [QDMTeamToBeVisionTrackerPoll] = []

            for (index, poll) in filteredPolls.reversed().enumerated() {
                if index == 3 {
                    break
                }
                lastPolls.append(poll)
            }
            completion(lastPolls)
        }
    }

    func getSortedClosedPollsWithRatings(allPolls: [QDMTeamToBeVisionTrackerPoll]?) -> [QDMTeamToBeVisionTrackerPoll] {
        let openPolls = allPolls?.filter { !$0.open } ?? []
        var openPollsWithRating = [QDMTeamToBeVisionTrackerPoll]()

        for openPoll in openPolls {
            if openPoll.qotTeamToBeVisionTrackers?.filter({ $0.qotTeamToBeVisionTrackerRatings?.isEmpty == false }).isEmpty == false {
                openPollsWithRating.append(openPoll)
            }
        }
        return openPollsWithRating
    }
}

// MARK: - Poll
extension WorkerTeam {
    func getCurrentTeamToBeVisionPoll(for team: QDMTeam,
                                      _ completion: @escaping (QDMTeamToBeVisionPoll?) -> Void) {
        TeamService.main.getCurrentTeamToBeVisionPoll(for: team) { (poll, _, error) in
            if let error = error {
                log("Error getCurrentTeamToBeVisionPoll: \(error.localizedDescription)", level: .error)
                // TODO handle error
            }
            completion(poll)
        }
    }

    func openNewTeamToBeVisionPoll(for team: QDMTeam,
                                   sendPushNotification: Bool,
                                   _ completion: @escaping (QDMTeamToBeVisionPoll?) -> Void) {
        TeamService.main.openNewTeamToBeVisionPoll(for: team,
                                                   sendPushNotification: sendPushNotification) { (poll, _, error) in
            if let error = error {
                log("Error openNewTeamToBeVisionPoll: \(error.localizedDescription)", level: .error)
                // TODO handle error
            }
            completion(poll)
        }
    }

    func closeTeamToBeVisionPoll(_ poll: QDMTeamToBeVisionPoll,
                                 _ completion: @escaping (QDMTeamToBeVisionPoll?) -> Void) {
        TeamService.main.closeTeamToBeVisionPoll(poll) { (poll, _, error) in
            if let error = error {
                log("Error closeTeamToBeVisionPoll: \(error.localizedDescription)", level: .error)
                // TODO handle error
            }
            completion(poll)
        }
    }

    func getTeamTBVPollRemainingDays(_ remainingDays: Int) -> NSAttributedString {
        let greyAttributes: [NSAttributedString.Key: Any]? = [.font: UIFont.sfProtextRegular(ofSize: 16),
                                                              .foregroundColor: UIColor.lightGrey]
        let redAttributes: [NSAttributedString.Key: Any]? = [.font: UIFont.sfProtextRegular(ofSize: 16),
                                                             .foregroundColor: UIColor.redOrange]
        let prefix = NSMutableAttributedString(string: AppTextService.get(.my_x_team_tbv_options_ends),
                                               attributes: greyAttributes)
        var string = ""
        switch remainingDays {
        case 0:
            string = AppTextService.get(.my_x_team_tbv_options_today)
        case 1:
            string = AppTextService.get(.my_x_team_tbv_options_tomorrow)
        default:
            string = AppTextService.get(.my_x_team_tbv_options_days).replacingOccurrences(of: "${days}",
                                                                                          with: String(remainingDays))
        }
        let suffix = NSMutableAttributedString(string: " " + string, attributes: redAttributes)
        prefix.append(suffix)
        return prefix
    }

    func dateString(for day: Int) -> String {
        if day == .zero {
            return "Today"
        } else if day == 1 {
            return "Yesterday"
        } else {
            return String(day) + " Days"
        }
    }

    func voteTeamToBeVisionPoll(_ poll: QDMTeamToBeVisionPoll,
                                question: QDMQuestion,
                                votes: [QDMAnswer],
                                _ completion: @escaping (QDMTeamToBeVisionPoll?) -> Void) {
        TeamService.main.voteTeamToBeVisionPoll(poll,
                                                question: question,
                                                votes: votes) { (poll, error) in
            if let error = error {
                log("Error voteTeamToBeVisionPoll: \(error.localizedDescription)", level: .error)
            }
            NotificationCenter.default.post(name: .didRateTBV, object: nil)
            completion(poll)
        }
    }

    // How to make QDMTeamToBeVisionTrackerVote intances
    // var vote = [QDMTeamToBeVisionTrackerVote]()
    // let poll: QDMTeamToBeVisionTrackerPoll = from some where
    // let vote = poll.qotTeamToBeVisionTrackers[index].voteWithRatingValue(9)
    // votes.append(vote)
    // If user tries to vote with already closed poll, it will return 'TeamToBeVisionTrakcerPollIsAlreadyClosed'
    // If user tries to vote on the poll which user alreay voted, it will return 'UserDidVoteTeamToBeVisionTrackerPoll'
    func voteTeamToBeVisionTrackerPoll(_ votes: [QDMTeamToBeVisionTrackerVote],
                                       _ completion: @escaping (QDMTeamToBeVisionTrackerPoll?) -> Void) {
        guard !votes.isEmpty else {
            completion(nil)
            return
        }

        TeamService.main.voteTeamToBeVisionTrackerPoll(votes) { (poll, error) in
            if let error = error {
                log("Error voteTeamToBeVisionTrackerPoll: \(error.localizedDescription)", level: .error)
            }
            completion(poll)
        }
    }

    func openNewTeamToBeVisionTrackerPoll(for team: QDMTeam,
                                          sendPushNotification: Bool,
                                          _ completion: @escaping (QDMTeamToBeVisionTrackerPoll?) -> Void) {
        TeamService.main.openNewTeamToBeVisionTrackerPoll(for: team,
                                                          sendPushNotification: sendPushNotification) { (poll, _, error) in
            if let error = error {
                log("Error openNewTeamToBeVisionTrackerPoll: \(error.localizedDescription)", level: .error)
            }
            completion(poll)
        }
    }

    func getRatingReport(_ completion: @escaping (QDMToBeVisionRatingReport?) -> Void) {
        UserService.main.getToBeVisionTrackingReport(last: 3) { (report) in
            completion(report)
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
                               isMyX: Bool,
                               teams: [QDMTeam],
                               _ completion: @escaping ([Team.Item]) -> Void) {
        var teamHeaderItems = [Team.Item]()
        if !invites.isEmpty {
            teamHeaderItems.append(Team.Item(invites: invites, invites.count))
        }
        teamHeaderItems.append(contentsOf: teams.compactMap { (team) -> Team.Item in
            return Team.Item(qdmTeam: team)
        })

        if teams.isEmpty == false && isMyX {
            teamHeaderItems.insert(Team.Item(myX: .myX), at: .zero)
        }
        completion(teamHeaderItems)
    }
}
