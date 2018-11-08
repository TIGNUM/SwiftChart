//
//  SigningInfoConfigurator.swift
//  QOT
//
//  Created by karmic on 28.05.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import Foundation

final class SigningInfoConfigurator: AppStateAccess {

    static func make() -> (SigningInfoViewController) -> Void {
        return { (viewController) in
            let router = SigningInfoRouter(viewController: viewController)
            let worker = SigningInfoWorker(model: SigningInfoModel(), services: appState.services)
            let presenter = SigningInfoPresenter(viewController: viewController)
            let interactor = SigningInfoInteractor(worker: worker, presenter: presenter, router: router)
            viewController.interactor = interactor
        }
    }
}
