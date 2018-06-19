//
//  SigningDigitConfigurator.swift
//  QOT
//
//  Created by karmic on 07.06.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import Foundation

final class SigningDigitConfigurator: AppStateAccess {

    static func make(email: String) -> (SigningDigitViewController) -> Void {
        return { (viewController) in
            let router = SigningDigitRouter(viewController: viewController)
            let worker = SigningDigitWorker(services: appState.services,
                                            networkManager: appState.networkManager,
                                            email: email)
            let presenter = SigningDigitPresenter(viewController: viewController)
            let interactor = SigningDigitInteractor(worker: worker, presenter: presenter, router: router)
            viewController.interactor = interactor
        }
    }
}
