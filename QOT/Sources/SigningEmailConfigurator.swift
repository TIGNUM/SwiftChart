//
//  SigningEmailConfigurator.swift
//  QOT
//
//  Created by karmic on 29.05.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import Foundation

final class SigningEmailConfigurator: AppStateAccess {

    static func make() -> (SigningEmailViewController) -> Void {
        return { (viewController) in
            let router = SigningEmailRouter(viewController: viewController)
            let worker = SigningEmailWorker(services: appState.services, networkManager: appState.networkManager)
            let presenter = SigningEmailPresenter(viewController: viewController)
            let interactor = SigningEmailInteractor(worker: worker, presenter: presenter, router: router)
            viewController.interactor = interactor
        }
    }
}
