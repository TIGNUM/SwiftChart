//
//  PermissionsConfigurator.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 30/04/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

final class PermissionsConfigurator: AppStateAccess {

    static func make() -> (PermissionsViewController) -> Void {
        return { (permissionsViewController) in
            let router = PermissionsRouter(permissionsViewController: permissionsViewController, permissionsManager: appState.permissionsManager)
            let worker = PermissionsWorker(services: appState.services, permissionsManager: appState.permissionsManager)
            let presenter = PermissionsPresenter(viewController: permissionsViewController)
            let interactor = PermissionsInteractor(worker: worker, router: router, presenter: presenter)
            permissionsViewController.interactor = interactor
        }
    }
}
