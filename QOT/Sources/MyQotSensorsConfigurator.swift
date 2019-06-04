//
//  MyQotSensorsConfigurator.swift
//  QOT
//
//  Created by Ashish Maheshwari on 15.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class MyQotSensorsConfigurator: AppStateAccess {
    static func configure(viewController: MyQotSensorsViewController) {
        let router =  MyQotSensorsRouter(viewController: viewController)
        let worker = MyQotSensorsWorker(services: appState.services)
        let presenter = MyQotSensorsPresenter(viewController: viewController)
        let interactor = MyQotSensorsInteractor(worker: worker, presenter: presenter, router: router)
        viewController.interactor = interactor
    }
}
