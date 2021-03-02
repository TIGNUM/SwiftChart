//
//  TeamEditInteractor.swift
//  QOT
//
//  Created by karmic on 23.06.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class TeamEditInteractor: TeamEditWorker {

    // MARK: - Properties
    private let presenter: TeamEditPresenterInterface!
    private var type: TeamEdit.View
    private var team: QDMTeam?
    private var members = [TeamEdit.Member]()
    private var maxTeamMemberCount: Int = .zero
    private var maxChars: Int = .zero

    // MARK: - Init
    init(presenter: TeamEditPresenterInterface, type: TeamEdit.View, team: QDMTeam?) {
        self.presenter = presenter
        self.type = type
        self.team = team
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter.setupView(type, teamName: team?.name)
        setInitialData()
    }
}

// MARK: - Private
private extension TeamEditInteractor {
    func setupMemberList(team: QDMTeam) {
        getTeamMembers(in: team) { (qdmMembers) in
           self.members = qdmMembers.compactMap { (qdmMember) -> TeamEdit.Member in
               return TeamEdit.Member(email: qdmMember.email ?? "",
                                      me: qdmMember.me,
                                      isOwner: qdmMember.isTeamOwner)
           }.sorted(by: { (first, second) -> Bool in
            if first.isOwner {
                return true
            }
            return first.email < second.email
           })
           self.presenter.refreshMemberList(at: [])
        }
    }

    func setInitialData() {
        if let team = team {
            setupMemberList(team: team)
        }
        if type == .memberInvite {
            getMaxTeamMemberCount { (max) in
                self.maxTeamMemberCount = max
                self.presenter.setupTextCounter(type: .memberInvite, max: max, teamName: nil)
            }
        } else {
            getMaxChars { [weak self] (max) in
                self?.maxChars = max
                self?.presenter.setupTextCounter(type: self?.type ?? .edit, max: max, teamName: self?.team?.name)
            }
            getMaxTeamMemberCount { (max) in
                self.maxTeamMemberCount = max
            }
        }
    }

    func showAlertIfNeeded(email: String?) -> Bool {
        if (members.filter {
            $0.me == true && $0.email.caseInsensitiveCompare(email ?? "") == .orderedSame
        }.first != nil) {
            let title = AppTextService.get(.generic_alert_unknown_error_title)
            let message = AppTextService.get(.team_invite_error_add_myself)
            presenter.presentErrorAlert(title, message)
            return true
        }
        if (members.filter {
            $0.email.caseInsensitiveCompare(email ?? "") == .orderedSame && $0.me == false
        }.first != nil) {
            let title = AppTextService.get(.generic_alert_unknown_error_title)
            let message = AppTextService.get(.team_invite_error_add_exisiting)
            presenter.presentErrorAlert(title, message)
            return true
        }
        if canSendInvite == false {
            let title = AppTextService.get(.generic_alert_unknown_error_title)
            let message = AppTextService.get(.my_x_team_invite_max_members)
            presenter.presentErrorAlert(title, message)
            return true
        }
        return false
    }
}

// MARK: - TeamEditInteractorInterface
extension TeamEditInteractor: TeamEditInteractorInterface {
    var getType: TeamEdit.View {
        return type
    }

    var sectionCount: Int {
        return TeamEdit.Section.allCases.count
    }

    var canSendInvite: Bool {
        return members.count <= maxTeamMemberCount
    }

    var maxMemberCount: Int {
        return maxTeamMemberCount
    }

    func rowCount(in section: Int) -> Int {
        switch TeamEdit.Section.allCases[section] {
        case .info: return 1
        case .members: return members.count
        }
    }

    func item(at index: IndexPath) -> String? {
        return members.at(index: index.row)?.email
    }

    func createTeam(_ name: String?) {
        let max = maxMemberCount
        type = .memberInvite
        createTeam(name) { [weak self] (team, error) in
            guard error == nil else {
                let title = AppTextService.get(.generic_alert_unknown_error_title)
                var subtitle = AppTextService.get(.my_x_team_create_default_error_description)
                if let teamError = (error as NSError?), teamError.domain == TeamServiceErrorDomain,
                    let code = TeamServiceErrorCode(rawValue: teamError.code) {
                    switch code {
                    case .DuplicatedTeamName:
                        subtitle = AppTextService.get(.my_x_team_create_duplicated_name_error_description)
                    default:
                        break
                    }
                }
                self?.presenter.presentErrorAlert(title, subtitle)
                self?.type = .create
                return
            }
            self?.team = team
            if let team = team, team.remoteID != .zero {
                self?.setupMemberList(team: team)
            } else {
                ///oh man, maybe owner email can be part of team?
                let email = SessionService.main.getCurrentSession()?.useremail ?? ""
                let member = TeamEdit.Member(email: email,
                                             me: true,
                                             isOwner: true)
                self?.members.append(member)
                self?.presenter.refreshMemberList(at: [])

            }
            self?.presenter.prepareMemberInvite(name, maxMemberCount: max)
        }
    }

    func updateTeamName(_ name: String?) {
        team?.name = name
        updateTeamName(team, { _, _  in })
    }

    func sendInvite(_ email: String?) {
        if !showAlertIfNeeded(email: email) {
            let row = members.count
            sendInvite(email, team: team) { [weak self] (member, _) in
                if let member = member {
                    let emails = self?.members.compactMap { $0.email } ?? []
                    if emails.contains(obj: email) == false {
                        self?.members.append(TeamEdit.Member(email: member.email ?? "",
                                                             me: member.me,
                                                             isOwner: member.isTeamOwner))
                    }
                    self?.presenter.refreshMemberList(at: [IndexPath(row: row,
                                                                     section: TeamEdit.Section.members.rawValue)])
                }
            }
        } else {
            presenter.refreshMemberList(at: [])
        }
    }
}
