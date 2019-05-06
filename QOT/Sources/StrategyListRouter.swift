//
//  StrategyListRouter.swift
//  QOT
//
//  Created by karmic on 15.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class StrategyListRouter {

    // MARK: - Properties

    private let viewController: StrategyListViewController

    // MARK: - Init

    init(viewController: StrategyListViewController) {
        self.viewController = viewController
    }
}

// MARK: - StrategyListRouterInterface

extension StrategyListRouter: StrategyListRouterInterface {
    func presentArticle(selectedID: Int?) {
        viewController.performSegue(withIdentifier: R.segue.strategyListViewController.knowStrategyArticleSegueIdentifier,
                                    sender: selectedID)
    }
}
