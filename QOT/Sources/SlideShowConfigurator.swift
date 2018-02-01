//
//  SlideShowConfigurator.swift
//  QOT
//
//  Created by Sam Wyndham on 07.12.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

final class SlideShowConfigurator: AppStateAccess {

    static func make() -> (SlideShowViewController) -> Void {
        return { (viewController) in
            let worker = SlideShowWorker(services: appState.services)
            let router = SlideShowRouter(appCoordinator: appState.appCoordinator)
            let presenter = SlideShowPresenter(viewController: viewController)
            let interactor = SlideShowInteractor(worker: worker, presenter: presenter, router: router)
            viewController.interactor = interactor
        }
    }
}
