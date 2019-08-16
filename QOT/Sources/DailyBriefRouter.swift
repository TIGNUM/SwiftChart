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

    private let viewController: DailyBriefViewController

    // MARK: - Init

    init(viewController: DailyBriefViewController) {
        self.viewController = viewController
    }
}

// MARK: - DailyBriefRouterInterface

extension DailyBriefRouter: DailyBriefRouterInterface {

    func presentWhatsHotArticle(selectedID: Int) {
        let identifier = R.storyboard.main.qotArticleViewController.identifier
        if let controller = R.storyboard
            .main().instantiateViewController(withIdentifier: identifier) as? ArticleViewController {
            ArticleConfigurator.configure(selectedID: selectedID, viewController: controller)
            viewController.present(controller, animated: true, completion: nil)
        }
    }

    func presentMyToBeVision() {

        let identifier = R.storyboard.myToBeVision.myVisionViewController.identifier
        let myVisionViewController = R.storyboard
            .myToBeVision().instantiateViewController(withIdentifier: identifier) as? MyVisionViewController
        if let myVisionViewController = myVisionViewController {
            MyVisionConfigurator.configure(viewController: myVisionViewController)
            viewController.pushToStart(childViewController: myVisionViewController)
        }
    }

    func presentStrategyList(selectedStrategyID: Int) {
        let identifier = R.storyboard.main.qotArticleViewController.identifier
        if let controller = R.storyboard.main()
            .instantiateViewController(withIdentifier: identifier) as? ArticleViewController {
            ArticleConfigurator.configure(selectedID: selectedStrategyID, viewController: controller)
            viewController.present(controller, animated: true, completion: nil)
        }
    }

    func presentToolsItems(selectedToolID: Int?) {
        if let controller = R.storyboard.tools().instantiateViewController(withIdentifier: R.storyboard.tools.qotToolsItemsViewController.identifier) as? ToolsItemsViewController {
            ToolsItemsConfigurator.make(viewController: controller, selectedToolID: selectedToolID)
            viewController.present(controller, animated: true, completion: nil)
        }
    }

    func showCustomizeTarget(_ data: RatingQuestionViewModel.Question?) {
        if
            let data = data,
            let controller = QuestionnaireViewController.viewController(with: data,
                                                                        delegate: viewController,
                                                                        controllerType: .customize) {
            viewController.navigationController?.pushViewController(controller, animated: true)
        }
    }

    func showSolveResults(solve: QDMSolve) {
        let configurator = SolveResultsConfigurator.make(from: solve)
        let solveResultsController = SolveResultsViewController(configure: configurator)
        viewController.present(solveResultsController, animated: true)
    }

    func showDailyCheckIn() {
        guard let vieController = R.storyboard.dailyCheckin.dailyCheckinStartViewController() else { return }
        DailyCheckinStartConfigurator.configure(viewController: vieController)
        let navigationController = UINavigationController(rootViewController: vieController)
        navigationController.isNavigationBarHidden = true
        viewController.present(navigationController, animated: true, completion: nil)
    }
}
