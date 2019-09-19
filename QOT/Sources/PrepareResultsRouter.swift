//
//  PrepareResultsRouter.swift
//  QOT
//
//  Created by karmic on 24.05.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class PrepareResultsRouter {

    // MARK: - Properties
    private weak var viewController: PrepareResultsViewController?

    // MARK: - Init
    init(viewController: PrepareResultsViewController) {
        self.viewController = viewController
    }
}

// MARK: - PrepareResultsRouterInterface
extension PrepareResultsRouter: PrepareResultsRouterInterface {
    func presentEditBenefits(benefits: String?, questionID: Int) {
        //TODO: Hook up DT to edit prepare benefits.
//        presentDecisionTree(for: .prepareBenefits(benefits: benefits,
//                                                  questionID: Prepare.Key.benefits.questionID,
//                                                  viewController))
    }

    func presentEditIntentions(_ viewModel: DTViewModel, question: QDMQuestion?) {
        let configurator = DTPrepareConfigurator.make(viewModel: viewModel, question: question)
        let controller = DTPrepareViewController(configure: configurator)
        controller.resultsDelegate = viewController
        viewController?.present(controller, animated: true)
    }

    func presentRelatedArticle(readMoreID: Int) {
        guard let controller = R.storyboard.main().instantiateViewController(withIdentifier: "QOT.ArticleViewController") as? ArticleViewController else { return }
        ArticleConfigurator.configure(selectedID: readMoreID, viewController: controller)
        AppDelegate.topViewController()?.present(controller, animated: true, completion: nil)
    }

    func didClickSaveAndContinue() {
        dismissChatBotFlow()
    }

    func presentEditStrategyView(_ relatedStrategyId: Int, _ selectedIDs: [Int]) {
        let configurator = ChoiceConfigurator.make(selectedIDs, relatedStrategyId)
        let controller = ChoiceViewController(configure: configurator)
        controller.delegate = viewController
        viewController?.present(controller, animated: true)
    }

    func dismiss() {
        viewController?.dismiss(animated: true, completion: nil)
    }

    func dismissChatBotFlow() {
        AppDelegate.current.launchHandler.dismissChatBotFlow()
    }
}
