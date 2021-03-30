//
//  GuidedStoryJourneyRouter.swift
//  QOT
//
//  Created by karmic on 28.03.21.
//  Copyright (c) 2021 Tignum. All rights reserved.
//

import UIKit

final class GuidedStoryJourneyRouter {

    // MARK: - Properties
    private weak var viewController: GuidedStoryJourneyViewController?

    // MARK: - Init
    init(viewController: GuidedStoryJourneyViewController?) {
        self.viewController = viewController
    }
}

// MARK: - GuidedStoryJourneyRouterInterface
extension GuidedStoryJourneyRouter: GuidedStoryJourneyRouterInterface {
    func dismiss() {
        viewController?.dismiss(animated: true, completion: nil)
    }
}
