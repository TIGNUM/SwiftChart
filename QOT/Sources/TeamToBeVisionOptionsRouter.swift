//
//  TeamToBeVisionOptionsRouter.swift
//  QOT
//
//  Created by Anais Plancoulaine on 15.09.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit

final class TeamToBeVisionOptionsRouter {

    // MARK: - Properties
    private weak var viewController: TeamToBeVisionOptionsViewController?

    // MARK: - Init
    init(viewController: TeamToBeVisionOptionsViewController?) {
        self.viewController = viewController
    }
}

// MARK: - TeamToBeVisionOptionsRouterInterface
extension TeamToBeVisionOptionsRouter: TeamToBeVisionOptionsRouterInterface {
    func dismiss() {
        viewController?.dismiss(animated: true, completion: nil)
    }
}
