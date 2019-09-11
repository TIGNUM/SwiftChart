//
//  DTMindsetConfigurator.swift
//  QOT
//
//  Created by karmic on 09.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

final class DTMindsetConfigurator {
    static func make() -> (DTMindsetViewController) -> Void {
        return { (viewController) in
            let router = DTMindsetRouter(viewController: viewController)
            let presenter = DTMindsetPresenter(viewController: viewController)
            let interactor = DTMindsetInteractor(presenter,
                                                 questionGroup: .MindsetShifter,
                                                 introKey: Mindset.QuestionKey.Intro)
            viewController.mindsetInteractor = interactor
            viewController.mindsetRouter = router
            viewController.interactor = interactor
            viewController.router = router
        }
    }
}
