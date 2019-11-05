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

    func presentWhatsHotArticle(selectedID: Int) {
        displayCoachPreparationScreen()
        return
        let identifier = R.storyboard.main.qotArticleViewController.identifier
        if let controller = R.storyboard
            .main().instantiateViewController(withIdentifier: identifier) as? ArticleViewController {
            ArticleConfigurator.configure(selectedID: selectedID, viewController: controller)
            viewController?.present(controller, animated: true, completion: nil)
        }
    }

    func presentCopyRight(copyrightURL: String?) {
        let popUpController = PopUpCopyrightViewController(delegate: viewController, copyrightURL: copyrightURL)
        popUpController.modalPresentationStyle = .overCurrentContext
        viewController?.present(popUpController, animated: true, completion: nil)
    }

    func presentMyToBeVision() {
        let identifier = R.storyboard.myToBeVision.myVisionViewController.identifier
        let myVisionViewController = R.storyboard
            .myToBeVision().instantiateViewController(withIdentifier: identifier) as? MyVisionViewController
        if let myVisionViewController = myVisionViewController {
            MyVisionConfigurator.configure(viewController: myVisionViewController)
            viewController?.pushToStart(childViewController: myVisionViewController)
        }
    }

    func presentStrategyList(selectedStrategyID: Int) {
        let identifier = R.storyboard.main.qotArticleViewController.identifier
        if let controller = R.storyboard.main()
            .instantiateViewController(withIdentifier: identifier) as? ArticleViewController {
            ArticleConfigurator.configure(selectedID: selectedStrategyID, viewController: controller)
            viewController?.present(controller, animated: true, completion: nil)
        }
    }

    func presentToolsItems(selectedToolID: Int?) {
        if let controller = R.storyboard.tools().instantiateViewController(withIdentifier: R.storyboard.tools.qotToolsItemsViewController.identifier) as? ToolsItemsViewController {
            ToolsItemsConfigurator.make(viewController: controller, selectedToolID: selectedToolID)
            viewController?.present(controller, animated: true, completion: nil)
            controller.backButton.isHidden = true
        }
    }

    func showCustomizeTarget(_ data: RatingQuestionViewModel.Question?) {
        if
            let data = data,
            let controller = QuestionnaireViewController.viewController(with: data,
                                                                        delegate: viewController,
                                                                        controllerType: .customize) {
            viewController?.present(controller, animated: true)
        }
    }

    func showSolveResults(solve: QDMSolve) {
        let configurator = SolveResultsConfigurator.make(from: solve, resultType: .solveDailyBrief)
        let solveResultsController = SolveResultsViewController(configure: configurator)
        viewController?.present(solveResultsController, animated: true)
    }

    /**
     * Method name: displayCoachPreparationScreen.
     * Description: method which is used to trigger the preparation in the coach screen.
     */
    func displayCoachPreparationScreen() {
        let configurator = DTPrepareConfigurator.make()
        let controller = DTPrepareViewController(configure: configurator)
        viewController?.present(controller, animated: true)
    }

    func openGuidedTrackAppLink(_ appLink: QDMAppLink?) {
        appLink?.launch()

    }

    func presentMyDataScreen() {
        let storyboardID = R.storyboard.myDataScreen.myDataScreenViewControllerID.identifier
        let myDataScreenViewController = R.storyboard
            .myDataScreen().instantiateViewController(withIdentifier: storyboardID) as? MyDataScreenViewController
        if let myDataScreenViewController = myDataScreenViewController {
            let configurator = MyDataScreenConfigurator.make()
            configurator(myDataScreenViewController)
            viewController?.pushToStart(childViewController: myDataScreenViewController)
        }
    }

    func showDailyCheckInQuestions() {
        guard let newController = R.storyboard.dailyCheckin.dailyCheckinQuestionsViewController() else { return }
        DailyCheckinQuestionsConfigurator.configure(viewController: newController)
        let navigationController = UINavigationController(rootViewController: newController)
        navigationController.isNavigationBarHidden = true
        viewController?.present(navigationController, animated: true, completion: nil)
    }
}
