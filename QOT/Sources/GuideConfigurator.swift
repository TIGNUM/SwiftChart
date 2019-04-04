//
//  GuideConfigurator.swift
//  QOT
//
//  Created by Sam Wyndham on 24/01/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

final class GuideConfigurator: AppStateAccess {
    static func make(badgeManager: BadgeManager?) -> Configurator<GuideViewController> {
        return { viewController in
            let router = GuideRouter(launchHandler: appState.launchHandler)
            let presenter = GuidePresenter(viewController: viewController)
            let worker = GuideWorker(services: appState.services, badgeManager: badgeManager)
            let guideObserver = GuideObserver(services: appState.services)
            let interactor = GuideInteractor(presenter: presenter, guideObserver: guideObserver, worker: worker)
            viewController.interactor = interactor
            viewController.router = router
        }
    }
}
