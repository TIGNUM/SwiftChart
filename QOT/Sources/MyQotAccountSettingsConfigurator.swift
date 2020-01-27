//
//  MyQotAccountSettingsConfigurator.swift
//  QOT
//
//  Created by Ashish Maheshwari on 08.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class MyQotAccountSettingsConfigurator {

    static func configure(viewController: MyQotAccountSettingsViewController) {
        let router = MyQotAccountSettingsRouter(viewController: viewController)
        let worker = MyQotAccountSettingsWorker(userService: UserService.main,
                                                contentService: ContentService.main)
        let presenter = MyQotAccountSettingsPresenter(viewController: viewController)
        let interactor = MyQotAccountSettingsInteractor(worker: worker, presenter: presenter, router: router)
        viewController.interactor = interactor
    }
}
