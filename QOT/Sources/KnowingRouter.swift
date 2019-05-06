//
//  KnowingRouter.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class KnowingRouter {

    // MARK: - Properties

    private let viewController: KnowingViewController

    // MARK: - Init

    init(viewController: KnowingViewController) {
        self.viewController = viewController
    }
}

// MARK: - KnowingRouterInterface

extension KnowingRouter: KnowingRouterInterface {
    func presentWhatsHotArticle(selectedID: Int) {
        viewController.performSegue(withIdentifier: R.segue.knowingViewController.knowArticleSegueIdentifier,
                                    sender: selectedID)
    }

    func presentStrategyList(selectedStrategyID: Int?) {
        viewController.performSegue(withIdentifier: R.segue.knowingViewController.knowStrategyListSegueIdentifier,
                                    sender: selectedStrategyID)
    }
}
