//
//  WalkthroughCoachConfigurator.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 23/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

final class WalkthroughCoachConfigurator: AppStateAccess {

    static func make() -> (WalkthroughCoachViewController) -> Void {
        return { (viewController) in
            let router = WalkthroughCoachRouter(viewController: viewController)
            let worker = WalkthroughCoachWorker()
            let presenter = WalkthroughCoachPresenter(viewController: viewController)
            let interactor = WalkthroughCoachInteractor(worker: worker, presenter: presenter, router: router)
            viewController.interactor = interactor
        }
    }
}
