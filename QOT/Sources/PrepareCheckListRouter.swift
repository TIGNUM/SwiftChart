//
//  PrepareCheckListRouter.swift
//  QOT
//
//  Created by karmic on 24.05.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class PrepareCheckListRouter {

    // MARK: - Properties

    private let viewController: PrepareCheckListViewController

    // MARK: - Init

    init(viewController: PrepareCheckListViewController) {
        self.viewController = viewController
    }
}

// MARK: - PrepareCheckListRouterInterface

extension PrepareCheckListRouter: PrepareCheckListRouterInterface {
    func presentEditIntensions(selectedAnswers: [DecisionTreeModel.SelectedAnswer],
                               answerFilter: String?,
                               questionID: Int) {
        presentDecisionTree(for: .prepareIntensions(selectedAnswers: selectedAnswers,
                                                    answerFilter: answerFilter,
                                                    questionID: questionID))
    }


    func presentEditBenefits(benefits: String?, questionID: Int) {
        presentDecisionTree(for: .prepareBenefits(benefits: benefits, questionID: questionID))
    }

    func presentRelatedArticle(readMoreID: Int) {
        guard let controller = R.storyboard.main().instantiateViewController(withIdentifier: "QOT.ArticleViewController") as? ArticleViewController else { return }
        ArticleConfigurator.configure(selectedID: readMoreID, viewController: controller)
        AppDelegate.topViewController()?.present(controller, animated: true, completion: nil)
    }

    func didClickSaveAndContinue() {

    }

    func openEditStrategyView(services: Services, relatedStrategies: [ContentCollection], selectedIDs: [Int]) {
        presentRelatedStrategies(services: services,
                                 relatedStrategies: relatedStrategies,
                                 selectedIDs: selectedIDs) { (choices, syncManager) in
                                    print("choices", choices)
        }
    }
}

private extension PrepareCheckListRouter {
    func presentRelatedStrategies(services: Services,
                                  relatedStrategies: [ContentCollection],
                                  selectedIDs: [Int],
                                  completion: ((_ selectedStrategies: [WeeklyChoice], _ syncManager: SyncManager) -> Void)?) {
        let viewModel = SelectWeeklyChoicesDataModel(services: services,
                                                     relatedContent: relatedStrategies,
                                                     selectedIDs: selectedIDs)
        let viewControllerToPresent = SelectWeeklyChoicesViewController(delegate: viewController,
                                                                        viewModel: viewModel,
                                                                        backgroundImage: nil)
        viewController.present(viewControllerToPresent, animated: true, completion: nil)
    }

    func presentDecisionTree(for type: DecisionTreeType) {
        let permissionsManager = AppCoordinator.appState.permissionsManager!
        let configurator = DecisionTreeConfigurator.make(for: type,
                                                         permissionsManager: permissionsManager)
        let controller = DecisionTreeViewController(configure: configurator)
        viewController.present(controller, animated: true)
    }
}
