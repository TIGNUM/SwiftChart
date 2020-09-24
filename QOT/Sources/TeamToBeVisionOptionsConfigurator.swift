//
//  TeamToBeVisionOptionsConfigurator.swift
//  QOT
//
//  Created by Anais Plancoulaine on 15.09.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class TeamToBeVisionOptionsConfigurator {
    static func make(viewController: TeamToBeVisionOptionsViewController,
                     type: TeamToBeVisionOptionsModel.Types,
                     poll: QDMTeamToBeVisionPoll?,
                     remainingDays: Int) {
        let presenter = TeamToBeVisionOptionsPresenter(viewController: viewController)
        let interactor = TeamToBeVisionOptionsInteractor(presenter: presenter,
                                                         type: type,
                                                         poll: poll,
                                                         remainingDays: remainingDays)
        viewController.interactor = interactor
    }
}
