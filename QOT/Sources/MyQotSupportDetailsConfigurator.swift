//
//  MyQotSupportDetailsConfigurator.swift
//  QOT
//
//  Created by Ashish Maheshwari on 14.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class MyQotSupportDetailsConfigurator {

    static func configure(viewController: MyQotSupportDetailsViewController, category: ContentCategory) {
        let router = MyQotSupportDetailsRouter(viewController: viewController)
        let worker =  MyQotSupportDetailsWorker(contentService: qot_dal.ContentService.main, category: category)
        let presenter = MyQotSupportDetailsPresenter(viewController: viewController)
        let interactor =  MyQotSupportDetailsInteractor(worker: worker, presenter: presenter, router: router)
        viewController.interactor = interactor
    }
}
