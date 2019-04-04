//
//  LevelThreeRouter.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class LevelThreeRouter {

    // MARK: - Properties

    private let viewController: LevelThreeViewController

    // MARK: - Init

    init(viewController: LevelThreeViewController) {
        self.viewController = viewController
    }
}

// MARK: - LevelThreeRouterInterface

extension LevelThreeRouter: LevelThreeRouterInterface {

}
