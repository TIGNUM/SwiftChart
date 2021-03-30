//
//  GuidedStorySurveyRouter.swift
//  QOT
//
//  Created by karmic on 28.03.21.
//  Copyright (c) 2021 Tignum. All rights reserved.
//

import UIKit

final class GuidedStorySurveyRouter {

    // MARK: - Properties
    private weak var viewController: GuidedStorySurveyViewController?

    // MARK: - Init
    init(viewController: GuidedStorySurveyViewController?) {
        self.viewController = viewController
    }
}

// MARK: - GuidedStorySurveyRouterInterface
extension GuidedStorySurveyRouter: GuidedStorySurveyRouterInterface {
    func dismiss() {
        viewController?.dismiss(animated: true, completion: nil)
    }
}
