//
//  WalkthroughSearchConfigurator.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 22/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

final class WalkthroughSearchConfigurator: AppStateAccess {

    static func make() -> (WalkthroughSearchViewController) -> Void {
        return { (viewController) in
            let router = WalkthroughSearchRouter(viewController: viewController)
            let worker = WalkthroughSearchWorker()
            let presenter = WalkthroughSearchPresenter(viewController: viewController)
            let interactor = WalkthroughSearchInteractor(worker: worker, presenter: presenter, router: router)
            viewController.interactor = interactor
        }
    }
}
