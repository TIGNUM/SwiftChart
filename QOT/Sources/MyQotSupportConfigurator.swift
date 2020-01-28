//
//  MyQotSupportConfigurator.swift
//  QOT
//
//  Created by Ashish Maheshwari on 13.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class MyQotSupportConfigurator {

    static func configure(viewController: MyQotSupportViewController) {
        let router = MyQotSupportRouter(viewController: viewController)
        let worker = MyQotSupportWorker(contentService: ContentService.main, userService: UserService.main)
        let presenter = MyQotSupportPresenter(viewController: viewController)
        let interactor = MyQotSupportInteractor(worker: worker, presenter: presenter, router: router)
        viewController.interactor = interactor
    }
}
