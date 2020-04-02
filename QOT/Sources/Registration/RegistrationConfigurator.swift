//
//  RegistrationConfigurator.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 08/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

final class RegistrationConfigurator {
    static func make(email: String?) -> (RegistrationViewController) -> Void {
        return { (viewController) in
            let presenter = RegistrationPresenter(viewController: viewController)
            let router = RegistrationRouter(viewController: viewController)
            let interactor = RegistrationInteractor(presenter: presenter,
                                                    router: router,
                                                    email: email)
            viewController.interactor = interactor
        }
    }
}
