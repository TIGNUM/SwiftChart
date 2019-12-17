//
//  MyQotAdminDCSixthQuestionSettingsInterface.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 12/12/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

protocol MyQotAdminDCSixthQuestionSettingsViewControllerInterface: class {
    func setupView()
}

protocol MyQotAdminDCSixthQuestionSettingsPresenterInterface {
    func setupView()
}

protocol MyQotAdminDCSixthQuestionSettingsInteractorInterface: Interactor {}

protocol MyQotAdminDCSixthQuestionSettingsRouterInterface {
    func dismiss()
}
