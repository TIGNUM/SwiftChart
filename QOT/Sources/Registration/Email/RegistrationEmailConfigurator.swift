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
            let presenter = RegistrationEmailPresenter(viewController: viewController)
            let interactor = RegistrationEmailInteractor(presenter: presenter, delegate: delegate)
            viewController.interactor = interactor
        }
    }
}
