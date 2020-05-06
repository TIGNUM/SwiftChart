//
//  RegisterIntroConfigurator.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 05/12/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

final class RegisterIntroConfigurator {
    static func make(showNextButton: Bool? = true) -> (RegisterIntroViewController) -> Void {
        return { (viewController) in
            let presenter = RegisterIntroPresenter(viewController: viewController)
            let interactor = RegisterIntroInteractor(presenter: presenter)
            viewController.interactor = interactor
            viewController.showNextButton = showNextButton
        }
    }
}
