//
//  OnboardingLoginConfigurator.swift
//  QOT
//
//  Created by karmic on 29.07.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

final class OnboardingLoginConfigurator {
    static func make() -> (OnboardingLoginViewController, OnboardingLoginDelegate) -> Void {
        return { (viewController, delegate) in
            let router = OnboardingLoginRouter(viewController: viewController)
            let worker = OnboardingLoginWorker()
            let presenter = OnboardingLoginPresenter(viewController: viewController)
            let interactor = OnboardingLoginInteractor(worker: worker, presenter: presenter, router: router, delegate: delegate)
            viewController.interactor = interactor
        }
    }
}
