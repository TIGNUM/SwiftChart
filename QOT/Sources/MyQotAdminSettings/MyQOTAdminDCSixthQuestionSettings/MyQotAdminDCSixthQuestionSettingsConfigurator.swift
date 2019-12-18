//
//  MyQotAdminDCSixthQuestionSettingsConfigurator.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 12/12/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

final class MyQotAdminDCSixthQuestionSettingsConfigurator {
    static func configure(viewController: MyQotAdminDCSixthQuestionSettingsViewController) {
        let presenter = MyQotAdminDCSixthQuestionSettingsPresenter(viewController: viewController)
        let interactor = MyQotAdminDCSixthQuestionSettingsInteractor(presenter: presenter)
        viewController.interactor = interactor
    }
}
