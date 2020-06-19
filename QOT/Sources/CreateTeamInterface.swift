//
//  CreateTeamInterface.swift
//  QOT
//
//  Created by karmic on 19.06.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import Foundation

protocol CreateTeamViewControllerInterface: class {
    func setupView()
}

protocol CreateTeamPresenterInterface {
    func setupView()
}

protocol CreateTeamInteractorInterface: Interactor {}

protocol CreateTeamRouterInterface {
    func dismiss()
}
