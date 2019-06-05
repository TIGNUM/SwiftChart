//
//  MyQotSiriShortcutsConfigurator.swift
//  QOT
//
//  Created by Ashish Maheshwari on 14.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class MyQotSiriShortcutsConfigurator: AppStateAccess {
    static func configure(viewController: MyQotSiriShortcutsViewController) {
        let router =  MyQotSiriShortcutsRouter(viewController: viewController)
        let worker = MyQotSiriShortcutsWorker(services: appState.services)
        let presenter = MyQotSiriShortcutsPresenter(viewController: viewController)
        let interactor = MyQotSiriShortcutsInteractor(worker: worker, presenter: presenter, router: router)
        viewController.interactor = interactor
    }
}
