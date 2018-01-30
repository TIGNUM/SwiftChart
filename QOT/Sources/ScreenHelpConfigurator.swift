//
//  ScreenHelpConfigurator.swift
//  QOT
//
//  Created by Lee Arromba on 14/12/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

class ScreenHelpConfigurator: AppStateAccess {
    static func make(_ screenHelp: ScreenHelp) -> Configurator<ScreenHelpViewController> {
        return { viewController in
            let router = ScreenHelpRouter(windowManager: appState.windowManager, viewController: viewController)
            let presenter = ScreenHelpPresenter(viewController: viewController)
            let dataWorker = ScreenHelpDataWorker(services: appState.services)
            let interactor = ScreenHelpInteractor(presenter: presenter,
                                                  router: router,
                                                  dataWorker: dataWorker,
                                                  screenHelp: screenHelp)
            viewController.interactor = interactor
        }
    }
}
