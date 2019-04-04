//
//  CoachRouter.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class CoachRouter {

    // MARK: - Properties

    private let viewController: CoachViewController

    // MARK: - Init

    init(viewController: CoachViewController) {
        self.viewController = viewController
    }
}

// MARK: - CoachRouterInterface

extension CoachRouter: CoachRouterInterface {

}
