//
//  OnoardingLoginConfigurator.swift
//  QOT
//
//  Created by karmic on 29.07.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

final class OnoardingLoginConfigurator: AppStateAccess {
    static func make() -> (OnoardingLoginViewController) -> Void {
        return { (viewController) in
            let router = OnoardingLoginRouter(viewController: viewController)
            let worker = OnoardingLoginWorker(services: appState.services)
            let presenter = OnoardingLoginPresenter(viewController: viewController)
            let interactor = OnoardingLoginInteractor(worker: worker, presenter: presenter, router: router)
            viewController.interactor = interactor
        }
    }
}
