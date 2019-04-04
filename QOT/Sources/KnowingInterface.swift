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
}

protocol KnowingPresenterInterface {
    func setupView()
}

protocol KnowingInteractorInterface: Interactor {
    func whatsHotArticles() -> [Knowing.WhatsHotItem]
    func fiftyFiveStrategies() -> [Knowing.StrategyItem]
    func strategies() -> [Knowing.StrategyItem]
    func foundationStrategy() -> Knowing.StrategyItem?
    func presentWhatsHotArticle(at indexPath: IndexPath)
    func presentStrategyList(selectedStrategyID: Int)
}

protocol KnowingRouterInterface {
    func presentStrategyList(selectedStrategyID: Int)
}
