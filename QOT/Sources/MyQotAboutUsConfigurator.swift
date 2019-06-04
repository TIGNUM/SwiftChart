//
//  MyQotAboutUsConfigurator.swift
//  QOT
//
//  Created by Ashish Maheshwari on 13.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class MyQotAboutUsConfigurator: AppStateAccess {
    
    static func configure(viewController: MyQotAboutUsViewController) {
        let router = MyQotAboutUsRouter(viewController: viewController)
        let worker = MyQotAboutUsWorker(services: appState.services)
        let presenter = MyQotAboutUsPresenter(viewController: viewController)
        let interactor = MyQotAboutUsInteractor(worker: worker, presenter: presenter, router: router)
        viewController.interactor = interactor
    }
}
