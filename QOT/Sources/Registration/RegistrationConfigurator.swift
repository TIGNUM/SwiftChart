//
//  RegistrationConfigurator.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 08/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class RegistrationConfigurator {

    static func make() -> (RegistrationViewController) -> Void {
        return { (viewController) in
            let router = RegistrationRouter(viewController: viewController)
            let worker = RegistrationWorker()
            let presenter = RegistrationPresenter(viewController: viewController)
            let interactor = RegistrationInteractor(worker: worker, presenter: presenter, router: router)
            viewController.interactor = interactor
        }
    }
}
