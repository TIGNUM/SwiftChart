//
//  KnowingInteractor.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class KnowingInteractor {

    // MARK: - Properties

    private let worker: KnowingWorker
    private let presenter: KnowingPresenterInterface
    private let router: KnowingRouterInterface

    // MARK: - Init

    init(worker: KnowingWorker,
        presenter: KnowingPresenterInterface,
        router: KnowingRouterInterface) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
    }

    // MARK: - Interactor

    func viewDidLoad() {
        presenter.setupView()
    }
}

// MARK: - KnowingInteractorInterface

extension KnowingInteractor: KnowingInteractorInterface {
    func presentStrategyList(selectedStrategyID: Int?) {
        router.presentStrategyList(selectedStrategyID: selectedStrategyID)
    }

    func strategies() -> [Knowing.StrategyItem] {
        return worker.strategies
    }

    func fiftyFiveStrategies() -> [Knowing.StrategyItem] {
        return worker.fityFiveStrategies
    }

    func foundationStrategy() -> Knowing.StrategyItem? {
        return worker.foundationStrategy
    }

    func presentWhatsHotArticle(selectedID: Int) {
        router.presentWhatsHotArticle(selectedID: selectedID)
    }

    func whatsHotArticles() -> [Knowing.WhatsHotItem] {
        return worker.whatsHotItems
    }

    func header(for section: Knowing.Section) -> (title: String?, subtitle: String?) {
        return worker.header(for: section)
    }
}
