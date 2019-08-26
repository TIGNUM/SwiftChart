//
//  ToolsItemsInterface.swift
//  QOT
//
//  Created by Anais Plancoulaine on 23.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

protocol ToolsItemsViewControllerInterface: class {
    func setupView()
    func reload()
}

protocol ToolsItemsPresenterInterface {
    func setupView()
    func reload()
}

protocol ToolsItemsInteractorInterface: Interactor {
    var tools: [Tool.Item] { get }
    var rowCount: Int { get }
    var headerTitle: String { get }
    var headerSubtitle: String { get }
    func selectedContentId() -> Int
}

protocol ToolsItemsWorkerInterface {
    var headerTitle: String { get }
    var headerSubtitle: String { get }
    var tools: [Tool.Item] { get }
    func selectedContentId() -> Int
}
