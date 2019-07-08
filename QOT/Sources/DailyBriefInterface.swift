//
//  DailyBriefInterface.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

protocol DailyBriefViewControllerInterface: class {
    func setupView()
    func presentLevelTwo()
}

protocol DailyBriefPresenterInterface {
    func setupView()
}

protocol DailyBriefInteractorInterface: Interactor {
    func didTapCell(at: IndexPath)
    func whatsHotArticles() -> [Knowing.WhatsHotItem]
    func strategies() -> [Knowing.StrategyItem]
    func presentWhatsHotArticle(at indexPath: IndexPath)
    func presentStrategyList(selectedStrategyID: Int)
}

protocol DailyBriefRouterInterface {
    func didTapCell(at: IndexPath)
    func presentStrategyList(selectedStrategyID: Int)
}
