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
    private var selectedTeamItem: Team.Item?
    private var membersList: [TeamMember] = []
    private var maxTeamMemberCount: Int = 0

    // MARK: - Init
    init(presenter: MyXTeamMembersPresenterInterface, selectedTeamItem: Team.Item?, teamItems: [Team.Item]) {
        self.presenter = presenter
        self.selectedTeamItem = selectedTeamItem
        self.teamHeaderItems = teamItems
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter.setupView()
        presenter.updateTeamHeader(teamHeaderItems: teamHeaderItems)
        if let teamId = selectedTeamItem?.teamId {
            setHeaderItemSelected(teamId: teamId)
        }

        worker.getMaxTeamMemberCount { (max) in
            self.maxTeamMemberCount = max
        }

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(checkSelection),
                                               name: .didSelectTeam,
                                               object: nil)
    }

    var teamMembersText: String {
        return worker.teamMembersText
    }
}
// MARK: - Private
private extension MyXTeamMembersInteractor {
    @objc func checkSelection(_ notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: String] else { return }
        if let teamId = userInfo[Team.KeyTeamId] {
            log("teamId: " + teamId, level: .debug)
            setHeaderItemSelected(teamId: teamId)
        }
    }

    func setHeaderItemSelected(teamId: String) {
        teamHeaderItems.forEach { (item) in
            item.selected = (teamId == item.teamId)
            if item.selected {
                selectedTeamItem = item
            }
        }
        refreshView()
    }
}

// MARK: - MyXTeamMembersInteractorInterface
extension MyXTeamMembersInteractor: MyXTeamMembersInteractorInterface {
    var canEdit: Bool {
        return selectedTeamItem?.thisUserIsOwner == true && maxTeamMemberCount > membersList.count
    }

    var rowCount: Int {
        return membersList.count
    }

    var getSelectedTeamItem: Team.Item? {
        return selectedTeamItem
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
        if let team = selectedTeamItem?.qdmTeam {
            self.worker.getTeamMemberItems(team: team, { [weak self] (membersList) in
                self?.membersList = membersList
                self?.presenter.updateView(hasMembers: membersList.isEmpty == false)
            })
        } else {
            self.presenter.updateView(hasMembers: self.membersList.isEmpty == false)
        }
    }
}
