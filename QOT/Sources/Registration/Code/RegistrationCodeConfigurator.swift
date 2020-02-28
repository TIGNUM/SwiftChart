//
//  RegistrationCodeConfigurator.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 10/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

final class RegistrationCodeConfigurator {

    static func make() -> (RegistrationCodeViewController, String, RegistrationDelegate) -> Void {
        return { (viewController, email, delegate) in
            let router = RegistrationCodeRouter(viewController: viewController)
            let presenter = RegistrationCodePresenter(viewController: viewController)
            let interactor = RegistrationCodeInteractor(email: email,
                                                        presenter: presenter,
                                                        router: router,
                                                        delegate: delegate)
            viewController.interactor = interactor
        }
    }
}
