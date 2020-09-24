//
//  DTTeamTBVConfigurator.swift
//  QOT
//
//  Created by karmic on 04.09.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class DTTeamTBVConfigurator {
    static func make(poll: QDMTeamToBeVisionPoll?) -> (DTTeamTBVViewController) -> Void {
        return { (viewController) in
            let router = DTTeamTBVRouter(viewController: viewController)
            let presenter = DTTeamTBVPresenter(viewController: viewController)
            let interactor = DTTeamTBVInteractor(presenter,
                                                 questionGroup: .TeamToBeVisionPoll,
                                                 introKey: DTTeamTBV.QuestionKey.Intro,
                                                 poll: poll)
            viewController.interactor = interactor
            viewController.router = router
        }
    }
}
