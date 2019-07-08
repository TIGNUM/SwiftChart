//
//  DailyBriefInteractor.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class DailyBriefInteractor {

    // MARK: - Properties

    private let worker: DailyBriefWorker
    private let presenter: DailyBriefPresenterInterface
    private let router: DailyBriefRouterInterface

    // MARK: - Init

    init(worker: DailyBriefWorker,
        presenter: DailyBriefPresenterInterface,
        router: DailyBriefRouterInterface) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
    }

    // MARK: - Interactor

    func viewDidLoad() {
        presenter.setupView()
    }
}

// MARK: - DailyBriefInteractorInterface

extension DailyBriefInteractor: DailyBriefInteractorInterface {
    func presentStrategyList(selectedStrategyID: Int) {
        router.presentStrategyList(selectedStrategyID: selectedStrategyID)
    }

    func strategies() -> [Knowing.StrategyItem] {
        return worker.strategies
    }

    func presentWhatsHotArticle(at indexPath: IndexPath) {

    }

    func whatsHotArticles() -> [Knowing.WhatsHotItem] {
        return worker.whatsHotItems
    }

    func didTapCell(at: IndexPath) {
        router.didTapCell(at: at)
    }
}
