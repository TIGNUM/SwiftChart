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
    func reload()
}

protocol ToolsPresenterInterface {
    func setupView()
    func present(for toolSection: ToolModel)
    func reload()
}

protocol ToolsInteractorInterface: Interactor {
    func tools() -> [ToolItem]
    func presentToolsCollections(selectedToolID: Int?)
}

protocol ToolsRouterInterface {
    func presentToolsCollections(selectedToolID: Int?)
}

protocol ToolsWorkerInterface {
    func toolsSections() -> ToolModel
    func tools(_ completion: @escaping ([ToolItem]) -> Void)
}
