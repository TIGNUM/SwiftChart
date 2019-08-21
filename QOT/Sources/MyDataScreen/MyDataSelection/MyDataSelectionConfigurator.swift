//
//  MyDataSelectionConfigurator.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 20/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class MyDataSelectionConfigurator {
    static func make() -> (MyDataSelectionViewController) -> Void {
        return { (viewController) in
            let router = MyDataSelectionRouter(viewController: viewController)
            let worker = MyDataSelectionWorker(contentService: qot_dal.ContentService.main)
            let presenter = MyDataSelectionPresenter(viewController: viewController)
            let interactor = MyDataSelectionInteractor(worker: worker, presenter: presenter)
            viewController.interactor = interactor
            viewController.router = router
        }
    }
}
