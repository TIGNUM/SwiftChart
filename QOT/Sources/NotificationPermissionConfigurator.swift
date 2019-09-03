//
//  NotificationPermissionConfigurator.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 14/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

final class NotificationPermissionConfigurator: AppStateAccess {

    static func make() -> (NotificationPermissionViewController) -> Void {
        return { (viewController) in
            let router = NotificationPermissionRouter(viewController: viewController)
            let worker = NotificationPermissionWorker()
            let presenter = NotificationPermissionPresenter(viewController: viewController)
            let interactor = NotificationPermissionInteractor(worker: worker,
                                                          presenter: presenter,
                                                          router: router,
                                                          permissionManager: AppCoordinator.appState.permissionsManager)
            viewController.interactor = interactor
        }
    }
}
