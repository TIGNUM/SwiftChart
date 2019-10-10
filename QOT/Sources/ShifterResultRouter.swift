//
//  ShifterResultRouter.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 10.05.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class ShifterResultRouter {

    // MARK: - Properties
    private weak var viewController: ShifterResultViewController?

    // MARK: - Init
    init(viewController: ShifterResultViewController) {
        self.viewController = viewController
    }
}

// MARK: - ShifterResultRouterInterface
extension ShifterResultRouter: ShifterResultRouterInterface {
    func dismiss() {
        viewController?.dismiss(animated: true)
    }

    func presentFeedback() {
        guard let controller = R.storyboard.resultsFeedback().instantiateInitialViewController() as? ResultsFeedbackViewController else { return }
        viewController?.present(controller, animated: true)
        controller.configure(text: AppTextService.get(AppTextKey.results_solve_view_feedback_mindset_shifter_title))
        viewController?.removeBottomNavigation()
    }
}
