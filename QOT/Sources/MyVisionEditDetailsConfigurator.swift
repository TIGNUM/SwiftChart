//
//  MyVisionEditDetailsConfigurator.swift
//  QOT
//
//  Created by Ashish Maheshwari on 27.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class MyVisionEditDetailsConfigurator: AppStateAccess {
    static func configure(originViewController: MyVisionViewController, viewController: MyVisionEditDetailsViewController, title: String, vision: String) {
        let wdigetManager = ExtensionsDataManager(services: appState.services)
        let worker = MyVisionEditDetailsWorker(title: title, vision: vision, widgetManager: wdigetManager)
        let presenter = MyVisionEditDetailsPresenter(viewController: viewController)
        let interactor = MyVisionEditDetailsInteractor(presenter: presenter, worker: worker)
        viewController.interactor = interactor
        viewController.delegate = originViewController
    }
}
