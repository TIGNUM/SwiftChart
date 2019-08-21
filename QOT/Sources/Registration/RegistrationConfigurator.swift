//
//  RegistrationConfigurator.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 08/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

final class RegistrationConfigurator: AppStateAccess {

    static func make() -> (RegistrationViewController, CachedToBeVision?) -> Void {
        return { (viewController, cachedTBV) in
            let router = RegistrationRouter(viewController: viewController)
            let worker = RegistrationWorker()
            let presenter = RegistrationPresenter(viewController: viewController)
            let interactor = RegistrationInteractor(worker: worker, presenter: presenter, router: router, cachedTBV: cachedTBV)
            viewController.interactor = interactor
        }
    }
}
