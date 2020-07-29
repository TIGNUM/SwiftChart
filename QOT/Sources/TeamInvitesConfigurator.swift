//
//  TeamInvitesConfigurator.swift
//  QOT
//
//  Created by karmic on 14.07.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class TeamInvitesConfigurator {
    static func make(teamItems: [Team.Item]) -> (TeamInvitesViewController) -> Void {
        return { (viewController) in
            let presenter = TeamInvitesPresenter(viewController: viewController)
            let interactor = TeamInvitesInteractor(presenter: presenter, teamItems: teamItems)
            viewController.interactor = interactor
        }
    }
}
