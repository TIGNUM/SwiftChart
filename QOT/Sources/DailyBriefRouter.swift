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

    }

    func didTapCell(at: IndexPath) {
        viewController.presentLevelTwo()
    }
}
