//
//  MyQotSensorsConfigurator.swift
//  QOT
//
//  Created by Ashish Maheshwari on 15.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class MyQotSensorsConfigurator {
    static func configure(viewController: MyQotSensorsViewController) {
        let router =  MyQotSensorsRouter(viewController: viewController)
        let worker = MyQotSensorsWorker(contentService: qot_dal.ContentService.main)
        let presenter = MyQotSensorsPresenter(viewController: viewController)
        let interactor = MyQotSensorsInteractor(worker: worker, presenter: presenter, router: router)
        viewController.interactor = interactor
    }
}
