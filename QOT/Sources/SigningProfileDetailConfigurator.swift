//
//  SigningProfileDetailConfigurator.swift
//  QOT
//
//  Created by karmic on 12.06.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import Foundation

final class SigningProfileDetailConfigurator: AppStateAccess {

    static func make(email: String,
                     password: String,
                     code: String,
                     country: UserCountry) -> (SigningProfileDetailViewController) -> Void {
        return { (viewController) in
            let router = SigningProfileDetailRouter(viewController: viewController)
            let worker = SigningProfileDetailWorker(services: appState.services,
                                                    networkManager: appState.networkManager,
                                                    syncManager: appState.syncManager,
                                                    email: email,
                                                    code: code,
                                                    password: password,
                                                    country: country)
            let presenter = SigningProfileDetailPresenter(viewController: viewController)
            let interactor = SigningProfileDetailInteractor(worker: worker, presenter: presenter, router: router)
            viewController.interactor = interactor
        }
    }
}
