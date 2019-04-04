//
//  DailyBriefRouter.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class DailyBriefRouter {

    // MARK: - Properties

    private let viewController: DailyBriefViewController

    // MARK: - Init

    init(viewController: DailyBriefViewController) {
        self.viewController = viewController
    }
}

// MARK: - DailyBriefRouterInterface

extension DailyBriefRouter: DailyBriefRouterInterface {
    func presentStrategyList(selectedStrategyID: Int) {
        let configurator = StrategyListConfigurator.make(selectedStrategyID: selectedStrategyID,
                                                         delegate: viewController.delegate)
        let controller = StrategyListViewController(configure: configurator)
        viewController.present(controller, animated: true, completion: nil)
    }

    func didTabCell(at: IndexPath) {
        viewController.presentLevelTwo()
    }
}
