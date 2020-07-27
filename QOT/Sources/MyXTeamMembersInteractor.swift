//
//  MyXTeamMembersInteractor.swift
//  QOT
//
//  Created by Anais Plancoulaine on 09.07.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class MyXTeamMembersInteractor {

    // MARK: - Properties
    private lazy var worker = MyXTeamMembersWorker()
    private let presenter: MyXTeamMembersPresenterInterface!
    private var teamHeaderItems = [Team.Item]()
    private var currentTeam: QDMTeam?
    private var membersList: [TeamMember] = []

    // MARK: - Init
    init(presenter: MyXTeamMembersPresenterInterface, team: QDMTeam?) {
        self.presenter = presenter
        self.currentTeam = team
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter.setupView()
        if let teamId = currentTeam?.qotId {
            updateSelectedTeam(teamId: teamId)
        }
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(checkSelection),
                                               name: .didSelectTeam,
                                               object: nil)
    }

    var teamMembersText: String {
        return worker.teamMembersText
    }

    func updateSelectedTeam(teamId: String) {
        worker.getTeamHeaderItems { [weak self] (teamHeaderItems) in
            self?.setHeaderItemSelected(teamHeaderItems: teamHeaderItems, teamId: teamId)
            self?.worker.setSelectedTeam(teamId: teamId, { [weak self] (selectedTeam) in
                self?.currentTeam = selectedTeam
                self?.refreshView()
            })
        }
    }
}
// MARK: - Private
private extension MyXTeamMembersInteractor {
    @objc func checkSelection(_ notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: String] else { return }
        if let teamId = userInfo[Team.KeyTeamId] {
            updateSelectedTeam(teamId: teamId)
        }
    }

    func setHeaderItemSelected(teamHeaderItems: [Team.Item], teamId: String) {
        self.teamHeaderItems = teamHeaderItems
        teamHeaderItems.forEach { (item) in
            item.selected = (teamId == item.teamId)
        }
    }
}

// MARK: - MyXTeamMembersInteractorInterface
extension MyXTeamMembersInteractor: MyXTeamMembersInteractorInterface {
    var canEdit: Bool {
        return currentTeam?.thisUserIsOwner == true
    }

    var rowCount: Int {
        return membersList.count
    }

    var selectedTeam: QDMTeam? {
        return currentTeam
    }

    func getMember(at indexPath: IndexPath) -> TeamMember? {
        return membersList.at(index: indexPath.row)
    }

    func removeMember(at indexPath: IndexPath) {
        if let member = getMember(at: indexPath) {
            worker.removeMember(member: member.member) { [weak self] in
                self?.refreshView()
            }
        }
    }

    func reinviteMember(at indexPath: IndexPath) {
        if let member = getMember(at: indexPath)?.member {
            worker.reInviteMember(member: member) { [weak self] (updatedMember) in
                self?.presenter.updateView(hasMembers: self?.membersList.isEmpty == false)
            }
        }
    }

    func refreshView() {
        if let team = currentTeam, let teamId = team.qotId {
            self.setHeaderItemSelected(teamHeaderItems: teamHeaderItems, teamId: teamId)
            self.worker.getTeamMemberItems(team: team, { [weak self] (membersList) in
                self?.membersList = membersList
                self?.presenter.updateTeamHeader(teamHeaderItems: self?.teamHeaderItems ?? [])
                self?.presenter.updateView(hasMembers: self?.membersList.isEmpty == false)
            })
        } else {
            self.presenter.updateView(hasMembers: self.membersList.isEmpty == false)
        }
    }
}
