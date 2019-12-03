//
//  DailyBriefRouter.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class DailyBriefRouter {

    // MARK: - Properties
    private weak var viewController: DailyBriefViewController?

    // MARK: - Init
    init(viewController: DailyBriefViewController) {
        self.viewController = viewController
    }
}

// MARK: - DailyBriefRouterInterface
extension DailyBriefRouter: DailyBriefRouterInterface {
    func presentCustomizeTarget(_ data: RatingQuestionViewModel.Question?) {
        if let data = data,
            let controller = QuestionnaireViewController.viewController(with: data,
                                                                        delegate: viewController,
                                                                        controllerType: .customize) {
            viewController?.present(controller, animated: true)
        }
    }

    func presentStrategyList(strategyID: Int?) {
        if let selectedID = strategyID,
            let controller = R.storyboard.main.qotArticleViewController() {
            ArticleConfigurator.configure(selectedID: selectedID, viewController: controller)
            viewController?.present(controller, animated: true)
        }
    }

    func presentToolsItems(toolID: Int?) {
        if let toolID = toolID,
            let controller = R.storyboard.tools.qotToolsItemsViewController() {
            ToolsItemsConfigurator.make(viewController: controller, selectedToolID: toolID)
            controller.backButton.isHidden = true
            viewController?.present(controller, animated: true)
        }
    }

    func presentWhatsHotArticle(articleID: Int?) {
        if let selectedID = articleID,
            let controller = R.storyboard.main.qotArticleViewController() {
            ArticleConfigurator.configure(selectedID: selectedID, viewController: controller)
            viewController?.present(controller, animated: true)
        }
    }

    func presentCopyRight(copyrightURL: String?) {
        let popUpController = PopUpCopyrightViewController(delegate: viewController, copyrightURL: copyrightURL)
        popUpController.modalPresentationStyle = .overCurrentContext
        viewController?.present(popUpController, animated: true)
    }

    func presentSolveResults(solve: QDMSolve) {
        let configurator = SolveResultsConfigurator.make(from: solve, resultType: .solveDailyBrief)
        let solveResultsController = SolveResultsViewController(configure: configurator)
        viewController?.present(solveResultsController, animated: true)
    }

    func presentDailyCheckInQuestions() {
        if let newController = R.storyboard.dailyCheckin.dailyCheckinQuestionsViewController() {
            DailyCheckinQuestionsConfigurator.configure(viewController: newController)
            let navigationController = UINavigationController(rootViewController: newController)
            navigationController.isNavigationBarHidden = true
            viewController?.present(navigationController, animated: true)
        }
    }

    func presentCoachPreparation() {
        let configurator = DTPrepareConfigurator.make()
        let controller = DTPrepareViewController(configure: configurator)
        viewController?.present(controller, animated: true)
    }

    func presentPrepareResults(for preparation: QDMUserPreparation?) {
        if let preparation = preparation {
            let configurator = PrepareResultsConfigurator.make(preparation, resultType: .prepareDailyBrief)
            let controller = PrepareResultsViewController(configure: configurator)
            viewController?.present(controller, animated: true)
        }
    }

    func showMyToBeVision() {
        if let childViewController = R.storyboard.myToBeVision.myVisionViewController() {
            MyVisionConfigurator.configure(viewController: childViewController)
            viewController?.pushToStart(childViewController: childViewController)
        }
    }

    func showMyDataScreen() {
        if let childViewController = R.storyboard.myDataScreen.myDataScreenViewControllerID() {
            let configurator = MyDataScreenConfigurator.make()
            configurator(childViewController)
            viewController?.pushToStart(childViewController: childViewController)
        }
    }

    func launchAppLinkGuidedTrack(_ appLink: QDMAppLink?) {
        appLink?.launch()
    }
}
