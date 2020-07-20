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
        if let teamId = team?.qotId {
            updateSelectedTeam(teamId: teamId)
        }
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter.setupView()
        refreshView()
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
            updateSelectedTeam(teamId: teamId)
        }
    }
}

// MARK: - MyXTeamMembersInteractorInterface
extension MyXTeamMembersInteractor: MyXTeamMembersInteractorInterface {
    var rowCount: Int {
        return membersList.count
    }

    var selectedTeam: QDMTeam? {
        return self.currentTeam
    }

    func getMember(at indexPath: IndexPath) -> TeamMember? {
        return membersList.at(index: indexPath.row)
    }

    func updateSelectedTeam(teamId: String) {
        worker.getTeamHeaderItems { [weak self] (teamHeaderItems) in
            self?.teamHeaderItems = teamHeaderItems
            teamHeaderItems.forEach { (item) in
                item.selected = (teamId == item.teamId)
            }
            self?.worker.setSelectedTeam(teamId: teamId, { [weak self] (selectedTeam) in
                self?.currentTeam = selectedTeam
                self?.presenter.updateTeamHeader(teamHeaderItems: teamHeaderItems)
                self?.presenter.updateView()
            })
        }
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
                print("member.status: \(member.status)")
                print("updatedMember?.status: \(updatedMember?.status)")
                self?.presenter.updateView()
            }
        }
    }

    func refreshView() {
        worker.getTeamHeaderItems { [weak self] (teamHeaderItems) in
            teamHeaderItems.first?.selected = true
            self?.teamHeaderItems = teamHeaderItems
            self?.presenter.updateTeamHeader(teamHeaderItems: teamHeaderItems)
            if let team = self?.currentTeam {
                self?.worker.getTeamMemberItems(team: team, { (membersList) in
                    self?.membersList.removeAll()
                    self?.membersList = membersList
                    self?.presenter.updateView()
                })
            } else {
                self?.presenter.updateView()
            }
        }
    }
}
