//
//  MyQotAdminSettingsListConfigurator.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 12/12/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

final class MyQotAdminSettingsListConfigurator {
    static func configure(viewController: MyQotAdminSettingsListViewController) {
        let presenter = MyQotAdminSettingsListPresenter(viewController: viewController)
        let interactor = MyQotAdminSettingsListInteractor(presenter: presenter)
        viewController.interactor = interactor
    }
}
