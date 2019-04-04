//
//  StrategyListInterface.swift
//  QOT
//
//  Created by karmic on 15.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

protocol StrategyListViewControllerInterface: class {
    func setupView()
}

protocol StrategyListPresenterInterface {
    func setupView()
}

protocol StrategyListInteractorInterface: Interactor {
    func contentList() -> [ContentCollection]
    func presentArticle(for selectedContent: ContentCollection)
}

protocol StrategyListRouterInterface {
    func presentArticle(services: Services, content: ContentCollection, contentCategory: ContentCategory)
}
