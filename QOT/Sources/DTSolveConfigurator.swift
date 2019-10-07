//
//  DTSolveConfigurator.swift
//  QOT
//
//  Created by karmic on 09.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

final class DTSolveConfigurator {
    static func make() -> (DTSolveViewController) -> Void {
        return { (viewController) in
            let router = DTSolveRouter(viewController: viewController)
            let presenter = DTSolvePresenter(viewController: viewController)
            let interactor = DTSolveInteractor(presenter, questionGroup: .Solve, introKey: Solve.QuestionKey.Intro)
            viewController.interactor = interactor
            viewController.solveRouter = router
            viewController.router = router
            viewController.shortTBVDelegate = interactor
        }
    }
}
