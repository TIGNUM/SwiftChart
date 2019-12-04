//
//  RegisterVideoIntroConfigurator.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 29/11/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class RegisterVideoIntroConfigurator {
    static func make() -> (RegisterVideoIntroViewController) -> Void {
        return { (viewController) in
            let router = RegisterVideoIntroRouter(viewController: viewController)
            let worker = RegisterVideoIntroWorker(contentService: qot_dal.ContentService.main)
            let presenter = RegisterVideoIntroPresenter(viewController: viewController)
            let interactor = RegisterVideoIntroInteractor(worker: worker, presenter: presenter)
            viewController.interactor = interactor
            viewController.router = router
        }
    }
}
