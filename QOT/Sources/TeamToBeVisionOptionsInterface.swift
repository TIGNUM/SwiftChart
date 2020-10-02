//
//  TeamToBeVisionOptionsInterface.swift
//  QOT
//
//  Created by Anais Plancoulaine on 15.09.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import Foundation
import qot_dal

protocol TeamToBeVisionOptionsViewControllerInterface: class {
     func setupView(type: TeamToBeVisionOptionsModel.Types, remainingDays: Int)
}

protocol TeamToBeVisionOptionsPresenterInterface {
    func setupView(type: TeamToBeVisionOptionsModel.Types, remainingDays: Int)
}

protocol TeamToBeVisionOptionsInteractorInterface: Interactor {
    var getType: TeamToBeVisionOptionsModel.Types { get }
    var daysLeft: Int { get }
    func showRateScreen()
    func endRating()
}

protocol TeamToBeVisionOptionsRouterInterface {
    func dismiss()
    func showRateScreen(with id: Int, team: QDMTeam?, type: Explanation.Types)
}
