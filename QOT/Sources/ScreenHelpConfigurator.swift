//
//  ScreenHelpConfigurator.swift
//  QOT
//
//  Created by Lee Arromba on 14/12/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

class ScreenHelpConfigurator: AppStateAccess {
    static func makeWith(key: ScreenHelp.Plist.Key) -> Configurator<ScreenHelpViewController> {
        return { viewController in
            let viewController = viewController
            let router = ScreenHelpRouter(windowManager: appState.windowManager, viewController: viewController)
            let presenter = ScreenHelpPresenter(viewController: viewController)
            let dataWorker = ScreenHelpDataWorker(plistName: ScreenHelp.Plist.name)
            let interactor = ScreenHelpInteractor(
                presenter: presenter, router: router, dataWorker: dataWorker, plistKey: key
            )
            viewController.interactor = interactor
        }
    }
}
