//
//  SolveResultsConfigurator.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 03.06.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class SolveResultsConfigurator {
    static func make(from selectedAnswer: QDMAnswer, type: ResultType, solve: QDMSolve?) -> (SolveResultsViewController) -> Void {
        return { (viewController) in
            let router = SolveResultsRouter(viewController: viewController)
            let worker = SolveResultsWorker(selectedAnswer: selectedAnswer, type: type, solve: nil)
            let presenter = SolveResultsPresenter(viewController: viewController)
            let interactor = SolveResultsInteractor(worker: worker, presenter: presenter, router: router)
            viewController.interactor = interactor
        }
    }

    static func make(from recoveryModel: QDMRecovery3D?) -> (SolveResultsViewController) -> Void {
        return { (viewController) in
            let router = SolveResultsRouter(viewController: viewController)
            let worker = SolveResultsWorker(recovery: recoveryModel)
            let presenter = SolveResultsPresenter(viewController: viewController)
            let interactor = SolveResultsInteractor(worker: worker, presenter: presenter, router: router)
            viewController.interactor = interactor
        }
    }

    static func make(from solve: QDMSolve) -> (SolveResultsViewController) -> Void {
        return { (viewController) in
            let router = SolveResultsRouter(viewController: viewController)
            let worker = SolveResultsWorker(selectedAnswer: solve.selectedAnswer!, type: .solve, solve: solve)
            let presenter = SolveResultsPresenter(viewController: viewController)
            let interactor = SolveResultsInteractor(worker: worker, presenter: presenter, router: router)
            viewController.interactor = interactor
            viewController.isFollowUpActive = solve.followUp
        }
    }

    static func make(from mindsetShifter: QDMMindsetShifter) -> (SolveResultsViewController) -> Void {
        return { (viewController) in
            let router = SolveResultsRouter(viewController: viewController)
            let worker = SolveResultsWorker(selectedAnswer: mindsetShifter.triggerAnswer, type: .solve, solve: nil)
            let presenter = SolveResultsPresenter(viewController: viewController)
            let interactor = SolveResultsInteractor(worker: worker, presenter: presenter, router: router)
            viewController.interactor = interactor
            viewController.isFollowUpActive = true
        }
    }
}
