//
//  DecisionTreeConfigurator.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 11.04.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

final class DecisionTreeConfigurator: AppStateAccess {

    static func make(for type: DecisionTreeType, permissionsManager: PermissionsManager) -> (DecisionTreeViewController) -> Void {
        return { (viewController) in
            let router = DecisionTreeRouter(viewController: viewController, permissionsManager: permissionsManager)
            let worker = DecisionTreeWorker(services: appState.services, type: type)
            let presenter = DecisionTreePresenter(viewController: viewController)
            let interactor = DecisionTreeInteractor(worker: worker, presenter: presenter, router: router)
            viewController.interactor = interactor
        }
    }
}
