//
//  DTSolveRouter.swift
//  QOT
//
//  Created by karmic on 09.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class DTSolveRouter: DTRouter {}

// MARK: - DTSolveRouterInterface
extension DTSolveRouter: DTSolveRouterInterface {
    func presentSolveResults(selectedAnswer: DTViewModel.Answer) {
        let configurator = SolveResultsConfigurator.make(from: selectedAnswer.remoteId,
                                                         solutionCollectionId: selectedAnswer.targetId(.content) ?? 0)
        let solveResultsController = SolveResultsViewController(configure: configurator)
        viewController?.present(solveResultsController, animated: true)
    }

    func loadShortTBVGenerator(introKey: String, delegate: DTShortTBVDelegate?, completion: (() -> Void)?) {
        let configurator = DTShortTBVConfigurator.make(introKey: introKey, delegate: delegate)
        let controller = DTShortTBVViewController(configure: configurator)
        viewController?.present(controller, animated: true, completion: completion)
    }

    func dismissFlowAndGoToMyTBV() {
        if let tbvURL = URLScheme.toBeVision.launchURLWithParameterValue("") {
            AppDelegate.current.launchHandler.process(url: tbvURL)
        }
    }
}
