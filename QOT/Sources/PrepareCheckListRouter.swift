//
//  PrepareCheckListRouter.swift
//  QOT
//
//  Created by karmic on 24.05.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class PrepareCheckListRouter {

    // MARK: - Properties

    private let viewController: PrepareCheckListViewController

    // MARK: - Init

    init(viewController: PrepareCheckListViewController) {
        self.viewController = viewController
    }
}

// MARK: - PrepareCheckListRouterInterface

extension PrepareCheckListRouter: PrepareCheckListRouterInterface {

}
