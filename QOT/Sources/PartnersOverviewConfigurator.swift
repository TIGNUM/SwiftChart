//
//  PartnersOverviewConfigurator.swift
//  QOT
//
//  Created by karmic on 15.05.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import Foundation

final class PartnersOverviewConfigurator: AppStateAccess {

    static func make() -> (PartnersOverviewViewController) -> Void {
        return { (viewController) in
            let router = PartnersOverviewRouter(viewController: viewController)
            let worker = PartnersOverviewWorker(services: appState.services,
                                                syncManager: appState.syncManager,
                                                networkManager: appState.networkManager)
            let presenter = PartnersOverviewPresenter(viewController: viewController)
            let interactor = PartnersOverviewInteractor(worker: worker, presenter: presenter, router: router)
            viewController.interactor = interactor
        }
    }
}
