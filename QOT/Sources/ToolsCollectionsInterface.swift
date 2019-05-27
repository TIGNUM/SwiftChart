//
//  ToolsCollectionsInterface.swift
//  QOT
//
//  Created by Anais Plancoulaine on 20.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

protocol ToolsCollectionsViewControllerInterface: class {
    func setupView()
}

protocol ToolsCollectionsPresenterInterface {
    func setupView()
}

protocol ToolsCollectionsInteractorInterface: Interactor {
    var videoTools: [Tool.Item] { get }
    var tools: [Tool.Item] { get }
    var rowCount: Int { get }
    var headerTitle: String { get }
    func presentToolsItems(selectedToolID: Int?)
}

protocol ToolsCollectionsRouterInterface {
    func presentToolsItems(selectedToolID: Int?)
}

protocol ToolsCollectionsWorkerInterface {
    var headerTitle: String { get }
    var tools: [Tool.Item] { get }
    var videoTools: [Tool.Item] { get }
}
