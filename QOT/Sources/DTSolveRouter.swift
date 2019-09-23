//
//  DTSolveRouter.swift
//  QOT
//
//  Created by karmic on 09.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class DTSolveRouter: DTRouter {

    // MARK: - Properties
    private weak var solveResultsController: SolveResultsViewController?
}

// MARK: - DTSolveRouterInterface
extension DTSolveRouter: DTSolveRouterInterface {
    func presentSolveResults(selectedAnswer: DTViewModel.Answer) {
        let configurator = SolveResultsConfigurator.make(from: selectedAnswer.remoteId,
                                                         solutionCollectionId: selectedAnswer.targetId(.content) ?? 0,
                                                         type: .solve,
                                                         solve: nil)
        let solveResultsController = SolveResultsViewController(configure: configurator)
        solveResultsController.delegate = self
        viewController?.present(solveResultsController, animated: true)
        self.solveResultsController = solveResultsController
    }

    func loadShortTBVGenerator(introKey: String, delegate: DTSolveInteractorInterface?, completion: (() -> Void)?) {

    }

    func dismissFlowAndGoToMyTBV() {

    }
}

// MARK: - ResultsViewControllerDelegate
extension DTSolveRouter: ResultsViewControllerDelegate {
    func didTapDismiss() {
         dismissChatBotFlow()
    }
}
