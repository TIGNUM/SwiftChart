//
//  MyVisionConfigurator.swift
//  QOT
//
//  Created by Ashish Maheshwari on 23.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class MyVisionConfigurator {
    static func configure(viewController: MyVisionViewController) {
        let router = MyVisionRouter(viewController: viewController)
        let widgetManager = ExtensionsDataManager()
        let worker = MyVisionWorker(userService: qot_dal.UserService.main,
                                    contentService: qot_dal.ContentService.main,
                                    widgetDataManager: widgetManager)
        let presenter = MyVisionPresenter(viewController: viewController)
        let interactor = MyVisionInteractor(presenter: presenter, worker: worker, router: router)
        viewController.interactor = interactor
    }
}
