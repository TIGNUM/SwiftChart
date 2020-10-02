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
    static func make(type: TeamToBeVisionOptionsModel.Types, remainingDays: Int, team: QDMTeam?) -> (TeamToBeVisionOptionsViewController) -> Void {
        return { (viewController) in
            let router = TeamToBeVisionOptionsRouter(viewController: viewController)
            let presenter = TeamToBeVisionOptionsPresenter(viewController: viewController)
            let interactor = TeamToBeVisionOptionsInteractor(presenter: presenter,
                                                             type: type,
                                                             router: router,
                                                             remainingDays: remainingDays,
                                                             team: team)
            viewController.interactor = interactor
        }
    }
}
