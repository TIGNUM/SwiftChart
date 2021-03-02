//
//  MyXTeamMembersInteractor.swift
//  QOT
//
//  Created by Anais Plancoulaine on 09.07.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class MyXTeamMembersInteractor: MyXTeamMembersWorker {

    // MARK: - Properties
    private let presenter: MyXTeamMembersPresenterInterface!
    private var selectedTeamItem: Team.Item?
    private var membersList: [TeamMember] = []
    private var maxTeamMemberCount: Int = .zero

    // MARK: - Init
    init(presenter: MyXTeamMembersPresenterInterface) {
        self.presenter = presenter
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter.setupView()
        getTeamHeaderItems(showNewRedDot: false) { [weak self] (items) in
            self?.setSelectedTeam(items)
            self?.presenter.updateTeamHeader(teamHeaderItems: items)
            self?.getMaxTeamMemberCount { (max) in
                self?.maxTeamMemberCount = max
            }
        }

        _ = NotificationCenter.default.addObserver(forName: .didSelectTeam,
                                                   object: nil,
                                                   queue: .main) { [weak self] notification in
            self?.checkSelection(notification)
        }
    }
}

// MARK: - Private
private extension MyXTeamMembersInteractor {
    @objc func checkSelection(_ notification: Notification) {
        guard let userInfo = notification.userInfo as? [String: String] else { return }
        if let teamId = userInfo[Team.KeyTeamId] {
            log("teamId: " + teamId, level: .debug)
            updateSelectedTeam(teamId: teamId)
        }
    }

    func setSelectedTeam(_ items: [Team.Item]) {
        selectedTeamItem = items.filter { $0.isSelected }.first
        if selectedTeamItem == nil {
            selectedTeamItem = items.first
            HorizontalHeaderView.selectedTeamId = selectedTeamItem?.teamId ?? ""
        }
        refreshView()
    }

    func updateSelectedTeam(teamId: String) {
        getTeamHeaderItems(showNewRedDot: false) { [weak self] (items) in
            self?.setSelectedTeam(items)
        }
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
            removeMember(member: member.member) { [weak self] in
                self?.refreshView()
            }
        }
    }

    func reinviteMember(at indexPath: IndexPath) {
        if let member = getMember(at: indexPath)?.member {
            reInviteMember(member: member) { [weak self] (_) in
                self?.presenter.updateView(hasMembers: self?.membersList.isEmpty == false)
            }
        }
    }

    func refreshView() {
        if let team = selectedTeamItem?.qdmTeam {
            getTeamMemberItems(team: team, { [weak self] (membersList) in
                self?.membersList = membersList
                self?.presenter.updateView(hasMembers: membersList.isEmpty == false)
            })
        } else {
            presenter.updateView(hasMembers: self.membersList.isEmpty == false)
        }
    }
}
