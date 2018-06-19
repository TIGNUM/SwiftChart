//
//  SigningLoginConfigurator.swift
//  QOT
//
//  Created by karmic on 05.06.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import Foundation

final class SigningLoginConfigurator: AppStateAccess {

    static func make(email: String) -> (SigningLoginViewController) -> Void {
        return { (viewController) in
            let router = SigningLoginRouter(viewController: viewController)
            let worker = SigningLoginWorker(services: appState.services,
                                            networkManager: appState.networkManager,
                                            syncManager: appState.syncManager,
                                            email: email)
            let presenter = SigningLoginPresenter(viewController: viewController)
            let interactor = SigningLoginInteractor(worker: worker, presenter: presenter, router: router)
            viewController.interactor = interactor
        }
    }
}
