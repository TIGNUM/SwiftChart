//
//  CreateTeamInteractor.swift
//  QOT
//
//  Created by karmic on 19.06.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class CreateTeamInteractor {

    // MARK: - Properties
    private lazy var worker = CreateTeamWorker()
    private let presenter: CreateTeamPresenterInterface!

    // MARK: - Init
    init(presenter: CreateTeamPresenterInterface) {
        self.presenter = presenter
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter.setupView()
    }
}

// MARK: - CreateTeamInteractorInterface
extension CreateTeamInteractor: CreateTeamInteractorInterface {
    func createTeam(_ name: String) {
        worker.createTeam(name) { [weak self] (team, initiated, error) in
            if let error = error {
                log("Error while create team: \(error.localizedDescription)", level: .error)
            } else {
                self?.presenter.presentInviteView()
            }
        }
    }
}
