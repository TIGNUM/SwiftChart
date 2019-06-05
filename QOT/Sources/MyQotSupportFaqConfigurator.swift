//
//  MyQotSupportFaqConfigurator.swift
//  QOT
//
//  Created by Ashish Maheshwari on 14.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class MyQotSupportFaqConfigurator: AppStateAccess {

    static func configure(viewController: MyQotSupportFaqViewController) {
        let router = MyQotSupportFaqRouter(viewController: viewController)
        let worker =  MyQotSupportFaqWorker(services: appState.services)
        let presenter = MyQotSupportFaqPresenter(viewController: viewController)
        let interactor =  MyQotSupportFaqInteractor(worker: worker, presenter: presenter, router: router)
        viewController.interactor = interactor
    }
}
