//
//  TeamInvitesConfigurator.swift
//  QOT
//
//  Created by karmic on 14.07.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import Foundation

final class TeamInvitesConfigurator {
    static func make() -> (TeamInvitesViewController) -> Void {
        return { (viewController) in
            let presenter = TeamInvitesPresenter(viewController: viewController)
            let interactor = TeamInvitesInteractor(presenter: presenter)
            viewController.interactor = interactor
        }
    }
}
