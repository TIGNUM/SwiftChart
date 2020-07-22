//
//  TeamToBeVisionConfigurator.swift
//  QOT
//
//  Created by Anais Plancoulaine on 20.07.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class TeamToBeVisionConfigurator {
    static func make(team: QDMTeam) -> (TeamToBeVisionViewController) -> Void {
        return { (viewController) in
            let router = TeamToBeVisionRouter(viewController: viewController)
            let presenter = TeamToBeVisionPresenter(viewController: viewController)
            let interactor = TeamToBeVisionInteractor(presenter: presenter, router: router, team: team)
            viewController.interactor = interactor
        }
    }
}
