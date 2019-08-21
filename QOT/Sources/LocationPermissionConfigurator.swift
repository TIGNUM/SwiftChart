//
//  LocationPermissionConfigurator.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 14/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

final class LocationPermissionConfigurator: AppStateAccess {

    static func make() -> (LocationPermissionViewController) -> Void {
        return { (viewController) in
            let router = LocationPermissionRouter(viewController: viewController)
            let worker = LocationPermissionWorker()
            let presenter = LocationPermissionPresenter(viewController: viewController)
            let interactor = LocationPermissionInteractor(worker: worker,
                                                          presenter: presenter,
                                                          router: router,
                                                          permissionManager: AppCoordinator.appState.permissionsManager)
            viewController.interactor = interactor
        }
    }
}
