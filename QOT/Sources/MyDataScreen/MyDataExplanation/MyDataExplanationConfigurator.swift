//
//  MyDataExplanationConfigurator.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 20/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class MyDataExplanationConfigurator {
    static func make() -> (MyDataExplanationViewController) -> Void {
        return { (viewController) in
            let router = MyDataExplanationRouter(viewController: viewController)
            let worker = MyDataExplanationWorker(contentService: qot_dal.ContentService.main)
            let presenter = MyDataExplanationPresenter(viewController: viewController)
            let interactor = MyDataExplanationInteractor(worker: worker, presenter: presenter)
            viewController.interactor = interactor
            viewController.router = router
        }
    }
}
