//
//  DTRecoveryConfigurator.swift
//  QOT
//
//  Created by karmic on 12.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

final class DTRecoveryConfigurator {
    static func make() -> (DTRecoveryViewController) -> Void {
        return { (viewController) in
            let router = DTRecoveryRouter(viewController: viewController)
            let presenter = DTRecoveryPresenter(viewController: viewController)
            let interactor = DTRecoveryInteractor(presenter,
                                                  questionGroup: .RecoveryPlan,
                                                  introKey: Recovery.QuestionKey.Intro)
            viewController.interactor = interactor
            viewController.recoveryInteractor = interactor
            viewController.recoveryRouter = router
        }
    }
}
