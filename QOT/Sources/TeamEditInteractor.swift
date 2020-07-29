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
    private var members = [QDMTeamMember]()
    private var maxTeamCount = 0
    private var maxChars = 0

    // MARK: - Init
    init(presenter: TeamEditPresenterInterface, type: TeamEdit.View, team: QDMTeam?) {
        self.presenter = presenter
        self.type = type
        self.team = team
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter.setupView(type)
        setInitialData()
    }
}

// MARK: - Private
private extension TeamEditInteractor {
    func setInitialData() {
        if let team = team {
            getTeamMembers(in: team) { (qdmMembers) in
                self.members = qdmMembers
                self.presenter.refreshMemberList(at: [])
             }
        }
        if type == .memberInvite {
            getMaxTeamCount { [weak self] (maxTeamCount) in
                self?.maxTeamCount = maxTeamCount
                self?.presenter.setupTextCounter(maxChars: maxTeamCount)
                _ = self?.showAlertIfNeeded(email: nil)
            }
        } else {
            getMaxChars { [weak self] (max) in
                self?.maxChars = max
                self?.presenter.setupTextCounter(maxChars: max)
            }
        }
    }

    func showAlertIfNeeded(email: String?) -> Bool {
        if (members.filter { $0.me == true && $0.email == email }.first != nil) {
            let title = AppTextService.get(.generic_alert_unknown_error_title)
            let message = AppTextService.get(.team_invite_error_add_myself)
            presenter.presentErrorAlert(title, message)
            return true
        }
        if (members.filter { $0.email == email && $0.me == false }.first != nil) {
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

    var rowCount: Int {
        return members.count
    }

    var teamName: String? {
        return team?.name
    }

    var canSendInvite: Bool {
        return members.count <= maxTeamCount
    }

    func item(at index: IndexPath) -> String? {
        return members.at(index: index.row)?.email
    }

    func createTeam(_ name: String?) {
        createTeam(name) { [weak self] (team, error) in
            self?.team = team
            if let team = team {
                self?.type = .memberInvite
                self?.presenter.prepareMemberInvite(team)
            }
        }
    }

    func updateTeamName(_ name: String?) {
        team?.name = name
        updateTeamName(team, { _, _  in })
    }

    func sendInvite(_ email: String?) {
        if !showAlertIfNeeded(email: email) {
            let row = rowCount
            sendInvite(email, team: team) { [weak self] (member, error) in
                if let member = member {
                    let emails = self?.members.compactMap { $0.email } ?? []
                    if emails.contains(obj: email) == false {
                        self?.members.append(member)
                    }
                    self?.presenter.refreshMemberList(at: [IndexPath(row: row, section: 0)])
                }
            }
        } else {
            presenter.refreshMemberList(at: [])
        }
    }
}
