//
//  MyQotAppSettingsConfigurator.swift
//  QOT
//
//  Created by Ashish Maheshwari on 10.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class MyQotAppSettingsConfigurator: AppStateAccess {
    
    static func configure(viewController: MyQotAppSettingsViewController) {
        let router =  MyQotAppSettingsRouter(viewController: viewController, services: appState.services)
        let worker = MyQotAppSettingsWorker(services: appState.services)
        let presenter = MyQotAppSettingsPresenter(viewController: viewController)
        let interactor = MyQotAppSettingsInteractor(worker: worker, presenter: presenter, router: router)
        viewController.interactor = interactor
    }
}


