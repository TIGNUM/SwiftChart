//
//  CreateTeamConfigurator.swift
//  QOT
//
//  Created by karmic on 19.06.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import Foundation

final class CreateTeamConfigurator {
    static func make() -> (CreateTeamViewController) -> Void {
        return { (viewController) in
            let presenter = CreateTeamPresenter(viewController: viewController)
            let interactor = CreateTeamInteractor(presenter: presenter)
            viewController.interactor = interactor
        }
    }
}
