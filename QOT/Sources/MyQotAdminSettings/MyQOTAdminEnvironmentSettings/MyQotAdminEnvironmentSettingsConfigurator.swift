//
//  MyQotAdminEnvironmentSettingsConfigurator.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 12/12/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

final class MyQotAdminEnvironmentSettingsConfigurator {
    static func configure(viewController: MyQotAdminEnvironmentSettingsViewController) {
        let presenter = MyQotAdminEnvironmentSettingsPresenter(viewController: viewController)
        let interactor = MyQotAdminEnvironmentSettingsInteractor(presenter: presenter)
        viewController.interactor = interactor
    }
}
