//
//  PrepareCheckListConfigurator.swift
//  QOT
//
//  Created by karmic on 24.05.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

final class PrepareCheckListConfigurator: AppStateAccess {

    static func make(contentID: Int) -> (PrepareCheckListViewController) -> Void {
        return { (viewController) in
            let router = PrepareCheckListRouter(viewController: viewController)
            let worker = PrepareCheckListWorker(services: appState.services, contentID: contentID)
            let presenter = PrepareCheckListPresenter(viewController: viewController)
            let interactor = PrepareCheckListInteractor(worker: worker, presenter: presenter, router: router)
            viewController.interactor = interactor
        }
    }
}
