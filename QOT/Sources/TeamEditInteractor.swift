//
//  TeamEditInteractor.swift
//  QOT
//
//  Created by karmic on 23.06.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class TeamEditInteractor {

    // MARK: - Properties
    private lazy var worker = TeamEditWorker()
    private let presenter: TeamEditPresenterInterface!
    private var type: TeamEdit.View
    private var team: QDMTeam?
    private var members = [QDMTeamMember]()

    // MARK: - Init
    init(presenter: TeamEditPresenterInterface, type: TeamEdit.View, team: QDMTeam?) {
        self.presenter = presenter
        self.type = type
        self.team = team
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter.setupView(type)
        worker.getMaxChars { [weak self] (max) in
            self?.presenter.setupTextCounter(maxChars: max)
        }
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

    func item(at index: IndexPath) -> String? {
        return members.at(index: index.row)?.email
    }

    func createTeam(_ name: String?) {
        worker.teamCreate(name) { [weak self] (team, _, error) in
            self?.team = team
            if let team = team {
                self?.type = .memberInvite
                self?.presenter.prepareMemberInvite(team)
            } else {
                log("Error while try to create team: \(error?.localizedDescription ?? "")", level: .error)
                self?.presenter.presentErrorAlert(error)
            }
        }
    }

    func sendInvite(_ email: String?) {
        worker.sendInvite(email, team: team) { [weak self] (member, _, error) in
            if let member = member {
                self?.members.append(member)
                self?.presenter.refreshMemberList()
            } else {
                log("Error while try to invite member: \(error?.localizedDescription ?? "")", level: .error)
                self?.presenter.presentErrorAlert(error)
            }
        }
    }

    func getMaxChars(_ completion: @escaping (Int) -> Void) {
        worker.getMaxChars(completion)
    }
}
