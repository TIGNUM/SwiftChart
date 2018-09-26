//
//  MyToBeVisionConfigurator.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 20/02/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

final class MyToBeVisionConfigurator: AppStateAccess {
    static func make() -> Configurator<MyToBeVisionViewController> {
        return { viewController in
            let router = MyToBeVisionRouter(viewController: viewController)
            let presenter = MyToBeVisionPresenter(viewController: viewController)
            let worker = MyToBeVisionWorker(services: appState.services,
                                            syncManager: appState.appCoordinator.syncManager)
            let interactor = MyToBeVisionInteractor(presenter: presenter, worker: worker, router: router)
            viewController.interactor = interactor
            viewController.router = router
            viewController.permissionsManager = appState.permissionsManager
        }
    }
}
