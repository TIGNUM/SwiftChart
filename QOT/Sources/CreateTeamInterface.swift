//
//  CreateTeamInterface.swift
//  QOT
//
//  Created by karmic on 19.06.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import Foundation
import qot_dal

protocol CreateTeamViewControllerInterface: class {
    func setupView()
    func setupLabels(header: String?, description: String?, buttonTitle: String?)
    func presentInviteView()
}

protocol CreateTeamPresenterInterface {
    func setupView()
    func presentInviteView()
}

protocol CreateTeamInteractorInterface: Interactor {
    func createTeam(_ name: String)
}

protocol CreateTeamRouterInterface {
    func dismiss()
    func presentInviteView()
}
