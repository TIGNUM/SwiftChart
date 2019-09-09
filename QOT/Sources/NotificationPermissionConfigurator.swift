//
//  NotificationPermissionConfigurator.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 14/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

final class NotificationPermissionConfigurator {

    static func make() -> (NotificationPermissionViewController) -> Void {
        return { (viewController) in
            let router = NotificationPermissionRouter(viewController: viewController)
            let worker = NotificationPermissionWorker(permissionManager: AppCoordinator.permissionsManager)
            let presenter = NotificationPermissionPresenter(viewController: viewController)
            let interactor = NotificationPermissionInteractor(worker: worker,
                                                          presenter: presenter,
                                                          router: router)
            viewController.interactor = interactor
        }
    }
}
