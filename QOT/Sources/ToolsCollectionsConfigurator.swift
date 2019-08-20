//
//  ToolsCollectionsConfigurator.swift
//  QOT
//
//  Created by Anais Plancoulaine on 20.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class ToolsCollectionsConfigurator {

    static func make(viewController: ToolsCollectionsViewController, selectedToolID: Int?) {
        let router = ToolsCollectionsRouter(viewController: viewController)
        let worker = ToolsCollectionsWorker(selectedToolID: selectedToolID)
        let presenter = ToolsCollectionsPresenter(viewController: viewController)
        let interactor = ToolsCollectionsInteractor(worker: worker, presenter: presenter, router: router)
        viewController.interactor = interactor
    }
}
