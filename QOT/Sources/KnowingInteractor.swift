//
//  KnowingInteractor.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

public extension Notification.Name {
    static let showKnowingSection = Notification.Name("showKnowingSection")
}

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
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didGetNotificationToShowsKnowingSection(_ :)),
                                               name: .showKnowingSection, object: nil)
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

    func reload() {
        presenter.reload()
    }

    func loadData() {
        worker.loadData()
    }
}

// MARK: - Notification

extension KnowingInteractor {
    @objc func didGetNotificationToShowsKnowingSection(_ notification: Notification) {
        guard let section = notification.object as? Knowing.Section else { return }
        switch section {
        case .strategies: break
        case .whatsHot: break
        default: break
        }
    }
}
