//
//  LevelTwoRouter.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class LevelTwoRouter {

    // MARK: - Properties

    private let viewController: LevelTwoViewController

    // MARK: - Init

    init(viewController: LevelTwoViewController) {
        self.viewController = viewController
    }
}

// MARK: - LevelTwoRouterInterface

extension LevelTwoRouter: LevelTwoRouterInterface {
    func didTapCell(at: IndexPath) {
        viewController.presentLevelThree()
    }
}
