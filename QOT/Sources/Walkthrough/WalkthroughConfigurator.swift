//
//  WalkthroughConfigurator.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 22/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

final class WalkthroughConfigurator: AppStateAccess {

    static func make() -> (WalkthroughViewController) -> Void {
        return { (viewController) in
            let router = WalkthroughRouter(viewController: viewController)
            let worker = WalkthroughWorker()
            let presenter = WalkthroughPresenter(viewController: viewController)
            let interactor = WalkthroughInteractor(worker: worker, presenter: presenter, router: router)
            viewController.interactor = interactor
        }
    }
}
