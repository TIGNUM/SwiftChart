//
//  PartnersLandingPageConfigurator.swift
//  QOT
//
//  Created by karmic on 09.05.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

final class PartnersLandingPageConfigurator: AppStateAccess {

    static func make() -> (PartnersLandingPageViewController) -> Void {
        return { (viewController) in
            let router = PartnersLandingPageRouter(viewController: viewController)
            let worker = PartnersLandingPageWorker(services: appState.services)
            let presenter = PartnersLandingPagePresenter(viewController: viewController)
            let interactor = PartnersLandingPageInteractor(worker: worker, presenter: presenter, router: router)
            viewController.interactor = interactor
        }
    }
}
