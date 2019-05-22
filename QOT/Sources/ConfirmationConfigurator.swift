//
//  ConfirmationConfigurator.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 09.05.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

final class ConfirmationConfigurator: AppStateAccess {

    static func make() -> (ConfirmationViewController) -> Void {
        return { (viewController) in
            let router = ConfirmationRouter(viewController: viewController)
            let worker = ConfirmationWorker(services: appState.services)
            let presenter = ConfirmationPresenter(viewController: viewController)
            let interactor = ConfirmationInteractor(worker: worker, presenter: presenter, router: router)
            viewController.interactor = interactor
        }
    }
}
