//
//  ShareConfigurator.swift
//  QOT
//
//  Created by Sam Wyndham on 01/03/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

final class ShareConfigurator: AppStateAccess {

    static func make(partnerLocalID: String, partnerName: String, partnerEmail: String) -> (ShareViewController) -> Void {
        return { (viewController) in
            let router = ShareRouter(viewController: viewController)
            let worker = ShareWorker(services: appState.services,
                                     partnerLocalID: partnerLocalID,
                                     networkManager: appState.networkManager,
                                     syncManager: appState.syncManager,
                                     name: partnerName)
            let presenter = SharePresenter(viewController: viewController)
            let interactor = ShareInteractor(worker: worker, router: router, presenter: presenter)
            viewController.interactor = interactor
        }
    }
}
