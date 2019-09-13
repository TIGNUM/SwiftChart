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
    static func make(from selectedAnswerId: Int,
                     solutionCollectionId: Int,
                     type: ResultType,
                     solve: QDMSolve?) -> (SolveResultsViewController) -> Void {
        return { (viewController) in
            let router = SolveResultsRouter(viewController: viewController)
            let worker = SolveResultsWorker(selectedAnswerId: selectedAnswerId,
                                            solutionCollectionId: solutionCollectionId,
                                            type: type,
                                            solve: nil)
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
            let worker = SolveResultsWorker(selectedAnswerId: solve.selectedAnswerId ?? 0,
                                            solutionCollectionId: solve.selectedAnswer?.targetId(.content) ?? 0,
                                            type: .solve,
                                            solve: solve)
            let presenter = SolveResultsPresenter(viewController: viewController)
            let interactor = SolveResultsInteractor(worker: worker, presenter: presenter, router: router)
            viewController.interactor = interactor
            viewController.isFollowUpActive = solve.followUp
        }
    }

    static func make(from mindsetShifter: QDMMindsetShifter) -> (SolveResultsViewController) -> Void {
        return { (viewController) in
            let router = SolveResultsRouter(viewController: viewController)
            let worker = SolveResultsWorker(selectedAnswerId: mindsetShifter.triggerAnswerId ?? 0,
                                            solutionCollectionId: mindsetShifter.triggerAnswer?.targetId(.content) ?? 0,
                                            type: .solve,
                                            solve: nil)
            let presenter = SolveResultsPresenter(viewController: viewController)
            let interactor = SolveResultsInteractor(worker: worker, presenter: presenter, router: router)
            viewController.interactor = interactor
            viewController.isFollowUpActive = true
        }
    }
}
