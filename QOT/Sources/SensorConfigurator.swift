//
//  SensorConfigurator.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 17/07/2018.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import Foundation

final class SensorConfigurator: AppStateAccess {

    static func make() -> (SensorViewController) -> Void {
        return { (viewController) in
            let router = SensorRouter(viewController: viewController)
            let worker = SensorWorker(services: appState.services)
            let presenter = SensorPresenter(viewController: viewController)
            let interactor = SensorInteractor(worker: worker, presenter: presenter, router: router)
            viewController.interactor = interactor
        }
    }
}
