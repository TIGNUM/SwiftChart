//
//  MyToBeVisionRateConfigurator.swift
//  QOT
//
//  Created by Ashish Maheshwari on 24.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class MyToBeVisionRateConfigurator {
    static func configure(viewController: MyToBeVisionRateViewController,
                          delegate: TBVRateDelegate?,
                          visionId: Int) {
        let router = MyToBeVisionRateRouter(viewController: viewController)
        let worker = MyToBeVisionRateWorker(visionId: visionId)
        let presenter = MyToBeVisionRatePresenter(viewController: viewController)
        let interactor = MyToBeVisionRateInteractor(presenter: presenter,
                                                    worker: worker,
                                                    router: router,
                                                    isoDate: Date())
        viewController.interactor = interactor
        viewController.delegate = delegate
    }
}
