//
//  SupportFAQConfigurator.swift
//  QOT
//
//  Created by karmic on 01.10.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import Foundation

final class SupportFAQConfigurator: AppStateAccess {

    static func make() -> (SupportFAQViewController) -> Void {
        return { (viewController) in
            let worker = SupportFAQWorker(services: appState.services)
            let presenter = SupportFAQPresenter(viewController: viewController)
            let interactor = SupportFAQInteractor(worker: worker, presenter: presenter)
            viewController.interactor = interactor
        }
    }
}
