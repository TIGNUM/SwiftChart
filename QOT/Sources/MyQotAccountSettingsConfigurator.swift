//
//  MyQotAccountSettingsConfigurator.swift
//  QOT
//
//  Created by Ashish Maheshwari on 08.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class MyQotAccountSettingsConfigurator: AppStateAccess {

    static func configure(viewController: MyQotAccountSettingsViewController) {
        let router = MyQotAccountSettingsRouter(viewController: viewController)
        let worker = MyQotAccountSettingsWorker(services: appState.services, syncManager: appState.appCoordinator.syncManager, networkManager: appState.networkManager)
        let presenter = MyQotAccountSettingsPresenter(viewController: viewController)
        let interactor = MyQotAccountSettingsInteractor(worker: worker, presenter: presenter, router: router)
        viewController.interactor = interactor
    }
}
