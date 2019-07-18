//
//  MyToBeVisionCountDownConfigurator.swift
//  QOT
//
//  Created by Ashish Maheshwari on 21.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class MyToBeVisionCountDownConfigurator {
    static func configure(on baseViewController: MyToBeVisionRateViewController, viewController: MyToBeVisionCountDownViewController) {
        let worker = MyToBeVisionCountDownWorker(delegate: baseViewController)
        let presenter = MyToBeVisionCountDownPresenter(viewController: viewController)
        let router = MyToBeVisionCountDownRouter(viewController: viewController)
        let interactor = MyToBeVisionCountDownInteractor(presenter: presenter, worker: worker, router: router)
        viewController.interactor = interactor
    }
}
