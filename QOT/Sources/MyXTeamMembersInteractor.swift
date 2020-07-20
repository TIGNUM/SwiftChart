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
    init(presenter: MyXTeamMembersPresenterInterface) {
        self.presenter = presenter
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
            worker.sendInvite(member.email, team: currentTeam) { (member, error) in
                //            if it was the last member,
                 //            if there are other teams --> team settings
                 //            if no other teams --> My profile
            }
        }
    }

    func reinviteMember(at indexPath: IndexPath) {
        if let member = getMember(at: indexPath) {
            worker.sendInvite(member.email, team: currentTeam) { (member, error) in

            }
        }
    }

    func refreshView() {
        worker.getTeamHeaderItems { [weak self] (teamHeaderItems) in
            teamHeaderItems.first?.selected = true
            self?.teamHeaderItems = teamHeaderItems
            self?.worker.setSelectedTeam(teamId: teamHeaderItems.first?.teamId ?? "", { [weak self] (selectedTeam) in
                self?.currentTeam = selectedTeam
                self?.presenter.updateTeamHeader(teamHeaderItems: teamHeaderItems)
                if let team = selectedTeam {
                    self?.worker.getTeamMemberItems(team: team, { (membersList) in
                        self?.membersList = membersList
                        self?.presenter.updateView()
                    })
                } else {
                    self?.presenter.updateView()
                }
            })
        }
    }
}
