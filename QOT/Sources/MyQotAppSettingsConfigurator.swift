//
//  MyQotAppSettingsConfigurator.swift
//  QOT
//
//  Created by Ashish Maheshwari on 10.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class MyQotAppSettingsConfigurator {

    static func configure(viewController: MyQotAppSettingsViewController) {
        let router =  MyQotAppSettingsRouter(viewController: viewController)
        let worker = MyQotAppSettingsWorker(contentService: qot_dal.ContentService.main)
        let presenter = MyQotAppSettingsPresenter(viewController: viewController)
        let interactor = MyQotAppSettingsInteractor(worker: worker, presenter: presenter, router: router)
        viewController.interactor = interactor
    }
}
