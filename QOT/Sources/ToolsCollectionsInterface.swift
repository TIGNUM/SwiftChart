//
//  ToolsCollectionsInterface.swift
//  QOT
//
//  Created by Anais Plancoulaine on 20.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

protocol ToolsCollectionsViewControllerInterface: class {
    func setupView()
    func reload()
    func audioPlayStateChangedForCellAt(indexPath: IndexPath)
}

protocol ToolsCollectionsPresenterInterface {
    func setupView()
    func reload()
    func audioPlayStateChangedForCellAt(indexPath: IndexPath)
}

protocol ToolsCollectionsInteractorInterface: Interactor {
    func isPlaying(remoteID: Int?) -> Bool
    var tools: [Tool.Item] { get }
    var rowCount: Int { get }
    var headerTitle: String { get }
    func presentToolsItems(selectedToolID: Int?)
    func selectedCategoryId() -> Int
    func contentItem(for id: Int, _ completion: @escaping (QDMContentItem?) -> Void)
    func presentDTMindetShifter()
    func presentDTRecovery()
}

protocol ToolsCollectionsRouterInterface: BaseRouterInterface {
    func presentToolsItems(selectedToolID: Int?)
}

protocol ToolsCollectionsWorkerInterface {
    var headerTitle: String { get }
    func tools(_ completion: @escaping ([Tool.Item]) -> Void)
    func selectedCategoryId() -> Int
}
