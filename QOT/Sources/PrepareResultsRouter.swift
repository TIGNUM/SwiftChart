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
    weak var delegate: CalendarEventSelectionDelegate?

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

    func presentMyPreps() {
        dismissChatBotFlow()
        if !(baseRootViewController?.navigationController?.viewControllers.last is MyPrepsViewController),
            let launchURL = URLScheme.myPreps.launchURLWithParameterValue("") {
            AppDelegate.current.launchHandler.process(url: launchURL)
        }
    }

    func presentCalendarPermission(_ permissionType: AskPermission.Kind, delegate: AskPermissionDelegate) {
         guard let controller = R.storyboard.askPermission().instantiateInitialViewController() as?
             AskPermissionViewController else { return }
         AskPermissionConfigurator.make(viewController: controller, type: permissionType, delegate: delegate)
         viewController?.present(controller, animated: true, completion: nil)
     }

    func presentCalendarSettings(delegate: SyncedCalendarsDelegate) {
        guard let controller = R.storyboard.myQot.syncedCalendarsViewController() else { return }
        SyncedCalendarsConfigurator.configure(viewController: controller,
                                              isInitialCalendarSelection: true,
                                              delegate: delegate)
        viewController?.present(controller, animated: true)
    }

    func presentCalendarEventSelection() {
        let configurator = CalendarEventSelectionConfigurator.make(delegate: delegate)
        let controller = CalendarEventSelectionViewController(configure: configurator)
        viewController?.present(controller, animated: true)
    }
}
