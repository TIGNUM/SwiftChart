//
//  PrepareResultsRouter.swift
//  QOT
//
//  Created by karmic on 24.05.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class PrepareResultsRouter: BaseRouter {

    // MARK: - Properties
    private weak var prepareResultsViewController: PrepareResultsViewController?

    // MARK: - Init
    init(viewController: PrepareResultsViewController) {
        super.init(viewController: viewController)
        self.prepareResultsViewController = viewController
    }
}

// MARK: - PrepareResultsRouterInterface
extension PrepareResultsRouter: PrepareResultsRouterInterface {
    func presentEditBenefits(benefits: String?, questionID: Int) {
//        presentDecisionTree(for: .prepareBenefits(benefits: benefits,
//                                                  questionID: Prepare.Key.benefits.questionID,
//                                                  viewController))
    }

    func presentEditIntentions(_ viewModel: DTViewModel, question: QDMQuestion?) {
        let configurator = DTPrepareConfigurator.make(viewModel: viewModel, question: question)
        let controller = DTPrepareViewController(configure: configurator)
        controller.resultsDelegate = prepareResultsViewController
        viewController?.present(controller, animated: true)
    }

    func didClickSaveAndContinue() {
        dismissChatBotFlow()
    }

    func presentEditStrategyView(_ relatedStrategyId: Int, _ selectedIDs: [Int]) {
        let configurator = ChoiceConfigurator.make(selectedIDs, relatedStrategyId)
        let controller = ChoiceViewController(configure: configurator)
        controller.delegate = prepareResultsViewController
        viewController?.present(controller, animated: true)
    }
}
