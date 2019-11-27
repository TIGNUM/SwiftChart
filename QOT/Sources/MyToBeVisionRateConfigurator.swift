//
//  MyToBeVisionRateConfigurator.swift
//  QOT
//
//  Created by Ashish Maheshwari on 24.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class MyToBeVisionRateConfigurator {
    static func configure(previousController: MyVisionViewController,
                          viewController: MyToBeVisionRateViewController,
                          visionId: Int) {
        let router = MyToBeVisionRateRouter(viewController: viewController)
        let worker = MyToBeVisionRateWorker(visionId: visionId, viewController: viewController)
        let presenter = MyToBeVisionRatePresenter(viewController: viewController)
        let interactor = MyToBeVisionRateInteractor(presenter: presenter,
                                                    worker: worker,
                                                    router: router,
                                                    isoDate: Date())
        viewController.interactor = interactor
        viewController.delegate = previousController
    }
}
