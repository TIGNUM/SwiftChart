//
//  WalkthroughSwipeConfigurator.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 23/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

final class WalkthroughSwipeConfigurator: AppStateAccess {

    static func make() -> (WalkthroughSwipeViewController) -> Void {
        return { (viewController) in
            let router = WalkthroughSwipeRouter(viewController: viewController)
            let worker = WalkthroughSwipeWorker()
            let presenter = WalkthroughSwipePresenter(viewController: viewController)
            let interactor = WalkthroughSwipeInteractor(worker: worker, presenter: presenter, router: router)
            viewController.interactor = interactor
        }
    }
}
