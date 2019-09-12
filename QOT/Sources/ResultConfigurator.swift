//
//  ResultConfigurator.swift
//  QOT
//
//  Created by karmic on 12.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class ResultConfigurator {
    static func make() -> (ResultViewController) -> Void {
        return { (viewController) in
            let router = ResultRouter(viewController: viewController)
            let worker = ResultWorker(contentService: qot_dal.ContentService.main)
            let presenter = ResultPresenter(viewController: viewController)
            let interactor = ResultInteractor(worker: worker, presenter: presenter)
            viewController.interactor = interactor
            viewController.router = router
        }
    }
}
