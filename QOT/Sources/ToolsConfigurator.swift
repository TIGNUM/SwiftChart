//
//  ToolsConfigurator.swift
//  QOT
//
//  Created by Anais Plancoulaine on 17.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class ToolsConfigurator: AppStateAccess {

    static func make(viewController: ToolsViewController?) {
        guard let viewController = viewController else { return }
        let router = ToolsRouter(viewController: viewController, services: appState.services)
        let worker = ToolsWorker(services: appState.services)
        let presenter = ToolsPresenter(viewController: viewController)
        let interactor = ToolsInteractor(worker: worker, presenter: presenter, router: router)
        viewController.interactor = interactor
    }
}
