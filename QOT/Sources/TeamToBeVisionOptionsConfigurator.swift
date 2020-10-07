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
                     toBeVisionPoll: QDMTeamToBeVisionPoll?,
                     trackerPoll: QDMTeamToBeVisionTrackerPoll?,
                     team: QDMTeam?) {
        let presenter = TeamToBeVisionOptionsPresenter(viewController: viewController)
        let interactor = TeamToBeVisionOptionsInteractor(presenter: presenter,
                                                         type: type,
                                                         trackerPoll: trackerPoll,
                                                         tobeVisionPoll: toBeVisionPoll,
                                                         team: team)
        viewController.interactor = interactor
    }
}
