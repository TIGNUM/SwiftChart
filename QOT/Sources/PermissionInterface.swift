//
//  PermissionInterface.swift
//  QOT
//
//  Created by Lee Arromba on 30/11/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

protocol PermissionInterface {
    func authorizationStatusDescription() -> PermissionsManager.AuthorizationStatus
    func askPermission(completion: @escaping (Bool) -> Void)
}
