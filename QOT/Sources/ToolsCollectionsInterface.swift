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
    var isPlaying: Bool { get }
    var videoTools: [Tool.Item] { get }
    var tools: [Tool.Item] { get }
    var rowCount: Int { get }
    var headerTitle: String { get }
    func presentToolsItems(selectedToolID: Int?)
    func selectedCategoryId() -> Int
    func contentItem(for id: Int, _ completion: @escaping (QDMContentItem?) -> Void)
}

protocol ToolsCollectionsRouterInterface {
    func presentToolsItems(selectedToolID: Int?)
}

protocol ToolsCollectionsWorkerInterface {
    var headerTitle: String { get }
    func tools(_ completion: @escaping ([Tool.Item]) -> Void)
    func videoTools(_ completion: @escaping ([Tool.Item]) -> Void)
    func selectedCategoryId() -> Int
}
