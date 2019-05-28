//
//  ToolsItemsConfigurator.swift
//  QOT
//
//  Created by Anais Plancoulaine on 23.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class ToolsItemsConfigurator: AppStateAccess {

    static func make(viewController: ToolsItemsViewController, selectedToolID: Int?) {
        let worker = ToolsItemsWorker(services: appState.services, selectedToolID: selectedToolID)
        let presenter = ToolsItemsPresenter(viewController: viewController)
        let interactor = ToolsItemsInteractor(worker: worker, presenter: presenter)
        viewController.interactor = interactor
    }
}
