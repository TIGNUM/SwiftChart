//
//  TeamVisionTrackerDetailsRouter.swift
//  QOT
//
//  Created by Anais Plancoulaine on 28.09.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit

final class TeamVisionTrackerDetailsRouter {

    // MARK: - Properties
    private weak var viewController: TeamVisionTrackerDetailsViewController?

    // MARK: - Init
    init(viewController: TeamVisionTrackerDetailsViewController?) {
        self.viewController = viewController
    }
}

// MARK: - TeamVisionTrackerDetailsRouterInterface
extension TeamVisionTrackerDetailsRouter: TeamVisionTrackerDetailsRouterInterface {
    func dismiss() {
        viewController?.dismiss(animated: true, completion: nil)
    }
}
