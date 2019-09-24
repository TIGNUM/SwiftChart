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
                     solutionCollectionId: Int) -> (SolveResultsViewController) -> Void {
        return { (viewController) in
            let worker = SolveResultsWorker(selectedAnswerId: selectedAnswerId,
                                            solutionCollectionId: solutionCollectionId)
            let presenter = SolveResultsPresenter(viewController: viewController)
            let interactor = SolveResultsInteractor(worker: worker, presenter: presenter)
            viewController.interactor = interactor
        }
    }

    static func make(from recoveryModel: QDMRecovery3D?, showSaveButton: Bool) -> (SolveResultsViewController) -> Void {
        return { (viewController) in
            let worker = SolveResultsWorker(recovery: recoveryModel)
            let presenter = SolveResultsPresenter(viewController: viewController)
            let interactor = SolveResultsInteractor(worker: worker, presenter: presenter)
            viewController.showSaveButton = showSaveButton
            viewController.interactor = interactor
        }
    }

    static func make(from solve: QDMSolve) -> (SolveResultsViewController) -> Void {
        return { (viewController) in
            let worker = SolveResultsWorker(solve: solve)
            let presenter = SolveResultsPresenter(viewController: viewController)
            let interactor = SolveResultsInteractor(worker: worker, presenter: presenter)
            viewController.interactor = interactor
        }
    }
}
