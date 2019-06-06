//
//  MyVisionConfigurator.swift
//  QOT
//
//  Created by Ashish Maheshwari on 23.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class MyVisionConfigurator: AppStateAccess {
    static func configure(viewController: MyVisionViewController) {
        let router = MyVisionRouter(viewController: viewController)
        let worker = MyVisionWorker(services: appState.services, permissionManager: appState.permissionsManager)
        let presenter = MyVisionPresenter(viewController: viewController)
        let interactor = MyVisionInteractor(presenter: presenter, worker: worker, router: router)
        viewController.interactor = interactor
    }
}
