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
    var isFoundation: Bool { get }
    var foundationStrategies: [Strategy.Item] { get }
    var strategies: [Strategy.Item] { get }
    var rowCount: Int { get }
    var headerTitle: String { get }
    func presentArticle(selectedID: Int?)
}

protocol StrategyListRouterInterface {
    func presentArticle(selectedID: Int?)
}
