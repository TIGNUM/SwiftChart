//
//  DTTeamTBVConfigurator.swift
//  QOT
//
//  Created by karmic on 04.09.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import Foundation

final class DTTeamTBVConfigurator {
    static func make() -> (DTTeamTBVViewController) -> Void {
        return { (viewController) in
            let router = DTTeamTBVRouter(viewController: viewController)
            let presenter = DTTeamTBVPresenter(viewController: viewController)
            let interactor = DTTeamTBVInteractor(presenter,
                                                 questionGroup: .TeamToBeVisionPoll,
                                                 introKey: DTTeamTBV.QuestionKey.Intro)
            viewController.interactor = interactor
            viewController.router = router
        }
    }
}
