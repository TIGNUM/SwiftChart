//
//  RegistrationAgeConfigurator.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 14/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

final class RegistrationAgeConfigurator {

    static func make() -> (RegistrationAgeViewController, RegistrationDelegate) -> Void {
        return { (viewController, delegate) in
            let router = RegistrationAgeRouter(viewController: viewController)
            let worker = RegistrationAgeWorker()
            let presenter = RegistrationAgePresenter(viewController: viewController)
            let interactor = RegistrationAgeInteractor(worker: worker, presenter: presenter, router: router, delegate: delegate)
            viewController.interactor = interactor
        }
    }
}
