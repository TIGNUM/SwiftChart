//
//  SolveResultsRouter.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 03.06.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class SolveResultsRouter: BaseRouter {

    // MARK: - Properties
    private weak var solveResultsViewController: SolveResultsViewController?

    // MARK: - Init
    init(viewController: SolveResultsViewController) {
        super.init(viewController: viewController)
        self.solveResultsViewController = viewController
    }
}

// MARK: - SolveResultsRouterInterface
extension SolveResultsRouter: SolveResultsRouterInterface {
    func openVisionGenerator() {
        let configurator = DTShortTBVConfigurator.make(introKey: ShortTBV.QuestionKey.IntroMindSet, delegate: nil)
        let controller = DTShortTBVViewController(configure: configurator)
        viewController?.present(controller, animated: true)
        viewController?.removeBottomNavigation()
    }

    func openMindsetShifter() {
        presentMindsetShifter()
        viewController?.removeBottomNavigation()
    }

    func openRecovery() {
        presentRecovery()
        viewController?.removeBottomNavigation()
    }

    func presentFeedback() {
        guard let controller = R.storyboard.resultsFeedback().instantiateInitialViewController() as? ResultsFeedbackViewController else { return }
        viewController?.present(controller, animated: true)
        controller.configure(text: AppTextService.get(.coach_tools_interactive_tool_3drecovery_questionnaire_section_body_body_last_step))
        viewController?.removeBottomNavigation()
    }
}
