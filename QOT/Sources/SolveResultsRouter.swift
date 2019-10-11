//
//  SolveResultsRouter.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 03.06.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class SolveResultsRouter {

    // MARK: - Properties
    private weak var viewController: SolveResultsViewController?

    // MARK: - Init
    init(viewController: SolveResultsViewController) {
        self.viewController = viewController
    }
}

// MARK: - SolveResultsRouterInterface
extension SolveResultsRouter: SolveResultsRouterInterface {
    func dismiss() {
        AppDelegate.current.launchHandler.dismissChatBotFlow()
    }

    func openContent(with id: Int) {
        AppDelegate.current.launchHandler.showContentCollection(id)
    }

    func openContentItem(with id: Int) {
        AppDelegate.current.launchHandler.showContentItem(id)
    }

    func openVisionGenerator() {
        let configurator = DTShortTBVConfigurator.make(introKey: ShortTBV.QuestionKey.IntroMindSet, delegate: nil)
        let controller = DTShortTBVViewController(configure: configurator)
        viewController?.present(controller, animated: true)
        viewController?.removeBottomNavigation()
    }

    func openMindsetShifter() {
        let configurator = DTMindsetConfigurator.make()
        let controller = DTMindsetViewController(configure: configurator)
        viewController?.present(controller, animated: true)
        viewController?.removeBottomNavigation()
    }

    func openRecovery() {
        let configurator = DTRecoveryConfigurator.make()
        let controller = DTRecoveryViewController(configure: configurator)
        viewController?.present(controller, animated: true)
        viewController?.removeBottomNavigation()
    }

    func presentFeedback() {
        guard let controller = R.storyboard.resultsFeedback().instantiateInitialViewController() as? ResultsFeedbackViewController else { return }
        viewController?.present(controller, animated: true)
        controller.configure(text: AppTextService.get(AppTextKey.results_solve_view_feedback_recovery_title))
        viewController?.removeBottomNavigation()
    }
}
