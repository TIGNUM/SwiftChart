//
//  PermissionsModel.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 30/04/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

struct Permission {

    let activated: PermissionsManager.AuthorizationStatus
    let identifier: PermissionsManager.Permission.Identifier
}
