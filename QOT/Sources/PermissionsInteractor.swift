//
//  PermissionsInteractor.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 30/04/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation
import EventKit
import Photos

final class PermissionsInteractor {

    let worker: PermissionsWorker
    let router: PermissionsRouterInterface
    let presenter: PermissionsPresenterInterface

    init(worker: PermissionsWorker, router: PermissionsRouterInterface, presenter: PermissionsPresenterInterface) {
        self.worker = worker
        self.router = router
        self.presenter = presenter
    }

    func viewDidLoad() {
        updatePermissions()
    }
}

extension PermissionsInteractor: PermissionsInteractorInterface {

    func didTapPermission(permission: PermissionsManager.Permission.Identifier) {
        router.didTapPermission(permission: permission)
    }

    func updatePermissions() {
        worker.permissions(completion: {
            self.presenter.load($0)
        })
    }
}
