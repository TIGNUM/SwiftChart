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

    func createTeam(_ name: String?) {
        worker.teamCreate(name) { [weak self] (team, _, error) in
            if error == nil, team != nil {
                self?.type = .memberInvite
            }
            self?.team = team
            self?.presenter.handleResponseCreate(team, error: error)
        }
    }

    func sendInvite(_ email: String?) {
        worker.sendInvite(email, team: team) { [weak self] (member, _, error) in
            self?.presenter.handleResponseMemberInvite(member, error: error)
        }
    }

    func getMaxChars(_ completion: @escaping (Int) -> Void) {
        worker.getMaxChars(completion)
    }
}
