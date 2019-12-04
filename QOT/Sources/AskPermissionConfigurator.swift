//
//  AskPermissionConfigurator.swift
//  QOT
//
//  Created by karmic on 26.08.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class AskPermissionConfigurator {
    static func make(viewController: AskPermissionViewController?,
                     type: AskPermission.Kind,
                     delegate: AskPermissionDelegate? = nil) {
        let presenter = AskPermissionPresenter(viewController: viewController)
        let interactor = AskPermissionInteractor(presenter: presenter, permissionType: type)
        viewController?.interactor = interactor
        viewController?.delegate = delegate
    }
}
