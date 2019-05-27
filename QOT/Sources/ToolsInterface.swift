//
//  ToolsInterface.swift
//  QOT
//
//  Created by Anais Plancoulaine on 17.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

protocol ToolsViewControllerInterface: class {
    func setupView()
    func setup(for toolSection: ToolModel)
}

protocol ToolsPresenterInterface {
    func setupView()
    func present(for toolSection: ToolModel)
}

protocol ToolsInteractorInterface: Interactor {
    func tools() -> [ToolItem]
    func presentToolsCollections(selectedToolID: Int?)
}

protocol ToolsRouterInterface {
    func presentToolsCollections(selectedToolID: Int?)
}

protocol ToolsWorkerInterface {
    var tools: [ToolItem] { get }
    func toolsSections() -> ToolModel
}
