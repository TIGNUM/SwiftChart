//
//  CoachInterface.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

protocol CoachViewControllerInterface: class {
    func setupView()
    func setup(for coachSection: CoachModel)
}

protocol CoachPresenterInterface {
    func setupView()
    func present(for coachSection: CoachModel)
}

protocol CoachInteractorInterface: Interactor {
    func handleTap(coachSection: CoachSection)
    func trackingKeys(at indexPath: IndexPath) -> String
}

protocol CoachRouterInterface {
     func handleTap(coachSection: CoachSection)
}
