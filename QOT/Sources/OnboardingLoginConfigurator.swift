//
//  OnboardingLoginConfigurator.swift
//  QOT
//
//  Created by karmic on 29.07.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

final class OnboardingLoginConfigurator {
    static func make() -> (OnboardingLoginViewController) -> Void {
        return { (viewController) in
            let presenter = OnboardingLoginPresenter(viewController: viewController)
            let interactor = OnboardingLoginInteractor(presenter: presenter)
            viewController.interactor = interactor
        }
    }
}
