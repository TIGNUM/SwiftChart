//
//  StrategyListPresenter.swift
//  QOT
//
//  Created by karmic on 15.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class StrategyListPresenter {

    // MARK: - Properties

    private weak var viewController: StrategyListViewControllerInterface?

    // MARK: - Init

    init(viewController: StrategyListViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - StrategyListInterface

extension StrategyListPresenter: StrategyListPresenterInterface {
    func setupView() {
        viewController?.setupView()
    }

    func reload() {
        viewController?.reload()
    }
}
