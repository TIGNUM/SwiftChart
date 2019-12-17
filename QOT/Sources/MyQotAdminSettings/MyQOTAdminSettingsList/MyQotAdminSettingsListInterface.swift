//
//  MyQotAdminSettingsListInterface.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 12/12/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

protocol MyQotAdminSettingsListViewControllerInterface: class {
    func setupView()
}

protocol MyQotAdminSettingsListPresenterInterface {
    func setupView()
}

protocol MyQotAdminSettingsListInteractorInterface: Interactor {}

protocol MyQotAdminSettingsListRouterInterface {
    func dismiss()
}
