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
    func reload()
    func audioPlayStateChangedForCellAt(indexPath: IndexPath)
}

protocol StrategyListPresenterInterface {
    func setupView()
    func reload()
    func audioPlayStateChangedForCellAt(indexPath: IndexPath)
}

protocol StrategyListInteractorInterface: class, Interactor {
    func isPlaying(remoteID: Int?) -> Bool
    var isFoundation: Bool { get }
    var foundationStrategies: [Strategy.Item] { get }
    var strategies: [Strategy.Item] { get }
    var rowCount: Int { get }
    var headerTitle: String { get }
    func presentArticle(selectedID: Int?)
    func selectedStrategyId() -> Int
    func reloadData()
    func loadStrategies()
}

protocol StrategyListRouterInterface {
    func presentArticle(selectedID: Int?)
}
