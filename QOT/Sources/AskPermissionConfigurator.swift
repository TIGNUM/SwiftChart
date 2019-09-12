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
        let router = AskPermissionRouter(viewController: viewController, delegate: delegate)
        let worker = AskPermissionWorker(contentService: qot_dal.ContentService.main, permissionType: type)
        let presenter = AskPermissionPresenter(viewController: viewController)
        let interactor = AskPermissionInteractor(worker: worker, presenter: presenter, router: router)
        viewController?.interactor = interactor
    }
}
