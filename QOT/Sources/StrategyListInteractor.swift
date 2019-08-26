//
//  StrategyListInteractor.swift
//  QOT
//
//  Created by karmic on 15.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class StrategyListInteractor {

    // MARK: - Properties

    private let worker: StrategyListWorker
    private let presenter: StrategyListPresenterInterface
    private let router: StrategyListRouterInterface

    // MARK: - Init

    init(worker: StrategyListWorker,
        presenter: StrategyListPresenterInterface,
        router: StrategyListRouterInterface) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
    }

    // MARK: - Interactor

    func viewDidLoad() {
        presenter.setupView()
    }
}

// MARK: - StrategyListInteractorInterface

extension StrategyListInteractor: StrategyListInteractorInterface {

    var headerTitle: String {
        return worker.headerTitle()
    }

    var isFoundation: Bool {
        return worker.isFoundation
    }

    var rowCount: Int {
        return worker.rowCount
    }

    var foundationStrategies: [Strategy.Item] {
        return worker.foundationStrategies
    }

    var strategies: [Strategy.Item] {
        return worker.strategies
    }

    func presentArticle(selectedID: Int?) {
        router.presentArticle(selectedID: selectedID)
    }

    func reloadData() {
        presenter.reload()
    }

    func selectedStrategyId() -> Int {
        return worker.selectedStrategyId()
    }
}
