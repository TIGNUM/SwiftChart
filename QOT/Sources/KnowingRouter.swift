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
    func presentStrategyList(selectedStrategyID: Int) {
        let configurator = StrategyListConfigurator.make(selectedStrategyID: selectedStrategyID,
                                                         delegate: viewController.delegate)
        let controller = StrategyListViewController(configure: configurator)
        viewController.present(controller, animated: true, completion: nil)
    }
}
