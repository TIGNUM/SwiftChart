//
//  KnowingInterface.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

protocol KnowingViewControllerInterface: class {
    func setupView()
    func reload()
}

protocol KnowingPresenterInterface {
    func setupView()
    func reload()
}

protocol KnowingInteractorInterface: class, Interactor {
    func whatsHotArticles() -> [Knowing.WhatsHotItem]
    func fiftyFiveStrategies() -> [Knowing.StrategyItem]
    func strategies() -> [Knowing.StrategyItem]
    func foundationStrategy() -> Knowing.StrategyItem?
    func presentWhatsHotArticle(selectedID: Int)
    func presentStrategyList(selectedStrategyID: Int?)
    func header(for section: Knowing.Section) -> (title: String?, subtitle: String?)
    func reload()
    func loadData()
}

protocol KnowingRouterInterface {
    func presentStrategyList(selectedStrategyID: Int?)
    func presentWhatsHotArticle(selectedID: Int)
}
