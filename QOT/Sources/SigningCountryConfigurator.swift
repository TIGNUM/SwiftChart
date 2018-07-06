//
//  SigningCountryConfigurator.swift
//  QOT
//
//  Created by karmic on 07.06.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import Foundation

final class SigningCountryConfigurator: AppStateAccess {

    static func make(userSigning: UserSigning) -> (SigningCountryViewController) -> Void {
        return { (viewController) in
            let router = SigningCountryRouter(viewController: viewController)
            let worker = SigningCountryWorker(services: appState.services,
                                              networkManager: appState.networkManager,
                                              userSigning: userSigning)
            let presenter = SigningCountryPresenter(viewController: viewController)
            let interactor = SigningCountryInteractor(worker: worker, presenter: presenter, router: router)
            viewController.interactor = interactor
        }
    }
}
