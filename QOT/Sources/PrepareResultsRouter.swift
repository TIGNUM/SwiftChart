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
        presentDecisionTree(for: .prepareBenefits(benefits: benefits,
                                                  questionID: PrepareResult.Key.benefits.questionID,
                                                  viewController))
    }

    func presentEditIntentions(_ selectedAnswers: [DecisionTreeModel.SelectedAnswer],
                               _ key: PrepareResult.Key,
                               answerFilter: String?) {
        presentDecisionTree(for: .prepareIntentions(selectedAnswers, answerFilter, key, viewController))
    }

    func presentRelatedArticle(readMoreID: Int) {
        guard let controller = R.storyboard.main().instantiateViewController(withIdentifier: "QOT.ArticleViewController") as? ArticleViewController else { return }
        ArticleConfigurator.configure(selectedID: readMoreID, viewController: controller)
        AppDelegate.topViewController()?.present(controller, animated: true, completion: nil)
    }

    func didClickSaveAndContinue() {
        viewController?.dismissResultView()
        dismiss()
    }

    func presentEditStrategyView(_ relatedStrategyId: Int, _ selectedIDs: [Int]) {
        let configurator = ChoiceConfigurator.make(selectedIDs, relatedStrategyId)
        let controller = ChoiceViewController(configure: configurator)
        controller.delegate = viewController
        viewController?.present(controller, animated: true)
    }

    func dismiss() {
        AppDelegate.current.launchHandler.dismissChatBotFlow()
    }
}

// MARK: - DecisionTreeViewController
private extension PrepareResultsRouter {
    func presentDecisionTree(for type: DecisionTreeType) {
        let configurator = DecisionTreeConfigurator.make(for: type)
        let controller = DecisionTreeViewController(configure: configurator)
        viewController?.present(controller, animated: true)
    }
}
