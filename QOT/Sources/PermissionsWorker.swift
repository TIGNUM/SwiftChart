//
//  PermissionsWorker.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 30/04/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

final class PermissionsWorker {

    private let services: Services
    private let permissionsManager: PermissionsManager

    init(services: Services, permissionsManager: PermissionsManager) {
        self.services = services
        self.permissionsManager = permissionsManager
    }

    func permissions(completion: @escaping ([Permission]) -> Void) {
        var permissions: [Permission] = []
        let dispatchGroup = DispatchGroup()

        permissionsManager.allPermissions.forEach { [unowned self] (permission) in
            dispatchGroup.enter()
            permissionsManager.askPermission(for: [permission.identifier], completion: { status in
                defer { dispatchGroup.leave() }
                guard let status = status[permission.identifier] else { return }
                permissions.append(Permission(activated: status, identifier: permission.identifier))
            })

            dispatchGroup.notify(queue: DispatchQueue.main) { completion(permissions) }
        }
    }
}
