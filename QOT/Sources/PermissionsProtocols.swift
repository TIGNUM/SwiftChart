//
//  PermissionsProtocols.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 30/04/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

protocol PermissionsViewControllerInterface: class {
    func setup(_ permissions: [Permission])
}

protocol PermissionsPresenterInterface {
    func load(_ permissions: [Permission])
}

protocol PermissionsInteractorInterface: Interactor {
    func didTapPermission(permission: PermissionsManager.Permission.Identifier)
    func updatePermissions()
}

protocol PermissionsRouterInterface {
    func didTapPermission(permission: PermissionsManager.Permission.Identifier)
}
