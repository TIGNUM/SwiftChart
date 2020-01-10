//
//  MyQOTAdminEditSprintsConfigurator.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 19/12/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

final class MyQOTAdminEditSprintsConfigurator {
    static func configure(viewController: MyQOTAdminEditSprintsViewController) {
        let presenter = MyQOTAdminEditSprintsPresenter(viewController: viewController)
        let interactor = MyQOTAdminEditSprintsInteractor(presenter: presenter)
        viewController.interactor = interactor
    }
}
