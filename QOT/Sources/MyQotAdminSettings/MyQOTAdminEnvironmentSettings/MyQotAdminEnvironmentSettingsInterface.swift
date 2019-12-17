//
//  MyQotAdminEnvironmentSettingsInterface.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 12/12/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

protocol MyQotAdminEnvironmentSettingsViewControllerInterface: class {
    func setupView()
}

protocol MyQotAdminEnvironmentSettingsPresenterInterface {
    func setupView()
}

protocol MyQotAdminEnvironmentSettingsInteractorInterface: Interactor {}

protocol MyQotAdminEnvironmentSettingsRouterInterface {
    func dismiss()
}
