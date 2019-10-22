//
//  CoachMarksRouter.swift
//  QOT
//
//  Created by karmic on 22.10.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class CoachMarksRouter {

    // MARK: - Properties
    private weak var viewController: CoachMarksViewController?

    // MARK: - Init
    init(viewController: CoachMarksViewController?) {
        self.viewController = viewController
    }
}

// MARK: - CoachMarksRouterInterface
extension CoachMarksRouter: CoachMarksRouterInterface {
    func dismiss() {
        viewController?.dismiss(animated: true, completion: nil)
    }
}
