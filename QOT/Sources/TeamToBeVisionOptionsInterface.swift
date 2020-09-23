//
//  TeamToBeVisionOptionsInterface.swift
//  QOT
//
//  Created by Anais Plancoulaine on 15.09.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import Foundation

protocol TeamToBeVisionOptionsViewControllerInterface: class {
     func setupView(type: TeamToBeVisionOptionsModel.Types, remainingDays: Int)
}

protocol TeamToBeVisionOptionsPresenterInterface {
    func setupView(type: TeamToBeVisionOptionsModel.Types, remainingDays: Int)
}

protocol TeamToBeVisionOptionsInteractorInterface: Interactor {
    var getType: TeamToBeVisionOptionsModel.Types { get }
    var daysLeft: Int { get }
    var alertCancelTitle: String { get }
    var alertEndTitle: String { get }
    func getTeamTBVPollRemainingDays(_ remainingDays: Int) -> NSAttributedString
}

protocol TeamToBeVisionOptionsRouterInterface {
    func dismiss()
}
