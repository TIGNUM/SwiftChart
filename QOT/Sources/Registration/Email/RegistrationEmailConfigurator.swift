//
//  RegistrationEmailConfigurator.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 08/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

final class RegistrationEmailConfigurator {

    static func make() -> (RegistrationEmailViewController, RegistrationDelegate) -> Void {
        return { (viewController, delegate) in
            let router = RegistrationEmailRouter(viewController: viewController)
            let worker = RegistrationEmailWorker()
            let presenter = RegistrationEmailPresenter(viewController: viewController)
            let interactor = RegistrationEmailInteractor(worker: worker, presenter: presenter, router: router, delegate: delegate)
            viewController.interactor = interactor
        }
    }
}
