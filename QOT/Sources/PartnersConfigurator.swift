//
//  ShareConfigurator.swift
//  QOT
//
//  Created by Sam Wyndham on 01/03/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

final class PartnersConfigurator: AppStateAccess {

    static func make() -> (PartnersViewController) -> Void {
        return { (viewController) in
            // FIXME: ImagePickerController should be loaded by router, not viewController
            let imagePickerController = ImagePickerController(cropShape: .hexagon,
                                                              imageQuality: .low,
                                                              imageSize: .small,
                                                              permissionsManager: appState.permissionsManager)
            imagePickerController.delegate = viewController
            viewController.imagePickerController = imagePickerController
            let router = PartnersRouter(viewController: viewController)
            let worker = PartnersWorker(services: appState.services,
                                        syncManager: appState.syncManager,
                                        networkManager: appState.networkManager)
            let presenter = PartnersPresenter(viewController: viewController)
            let interactor = PartnersInteractor(worker: worker, router: router, presenter: presenter)
            viewController.interactor = interactor
        }
    }
}
