//
//  SigningCreatePasswordConfigurator.swift
//  QOT
//
//  Created by karmic on 07.06.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import Foundation

final class SigningCreatePasswordConfigurator: AppStateAccess {

    static func make(userSigning: UserSigning?,
                     responseType: UserRegistrationCheck.ResponseType) -> (SigningCreatePasswordViewController) -> Void {
        return { (viewController) in
            let router = SigningCreatePasswordRouter(viewController: viewController)
            let worker = SigningCreatePasswordWorker(services: appState.services,
                                                     userSigning: userSigning,
                                                     responseType: responseType)
            let presenter = SigningCreatePasswordPresenter(viewController: viewController)
            let interactor = SigningCreatePasswordInteractor(worker: worker, presenter: presenter, router: router)
            viewController.interactor = interactor
        }
    }
}
