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
    func contentList() -> [ContentCollection] {
        return worker.contentList
    }

    func presentArticle(for selectedContent: ContentCollection) {
        guard let category = selectedContent.contentCategories.first else { return }
        router.presentArticle(services: worker.services,
                              content: selectedContent,
                              contentCategory: category)
    }
}
