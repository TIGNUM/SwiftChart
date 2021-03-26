//
//  GuidedStoryRouter.swift
//  QOT
//
//  Created by karmic on 26.03.21.
//  Copyright (c) 2021 Tignum. All rights reserved.
//

import UIKit

final class GuidedStoryRouter {

    // MARK: - Properties
    private weak var viewController: GuidedStoryViewController?

    // MARK: - Init
    init(viewController: GuidedStoryViewController?) {
        self.viewController = viewController
    }
}

// MARK: - GuidedStoryRouterInterface
extension GuidedStoryRouter: GuidedStoryRouterInterface {
    func dismiss() {
        viewController?.dismiss(animated: true, completion: nil)
    }
}
