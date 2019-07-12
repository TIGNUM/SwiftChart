//
//  MyQotAboutUsConfigurator.swift
//  QOT
//
//  Created by Ashish Maheshwari on 13.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class MyQotAboutUsConfigurator: AppStateAccess {

    static func configure(viewController: MyQotAboutUsViewController) {
        let router = MyQotAboutUsRouter(viewController: viewController)
        let worker = MyQotAboutUsWorker(contentService: qot_dal.ContentService.main)
        let presenter = MyQotAboutUsPresenter(viewController: viewController)
        let interactor = MyQotAboutUsInteractor(worker: worker, presenter: presenter, router: router)
        viewController.interactor = interactor
    }
}
