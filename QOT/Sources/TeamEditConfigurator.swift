//
//  TeamEditConfigurator.swift
//  QOT
//
//  Created by karmic on 23.06.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class TeamEditConfigurator {
    static func make(type: TeamEdit.View, team: QDMTeam?) -> (TeamEditViewController) -> Void {
        return { (viewController) in
            let presenter = TeamEditPresenter(viewController: viewController)
            let interactor = TeamEditInteractor(presenter: presenter, type: type, team: team)
            viewController.interactor = interactor
        }
    }
}
