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

protocol MyQotAdminEnvironmentSettingsInteractorInterface: Interactor {
    func getHeaderTitle() -> String
    func getTitle(at index: Int) -> String
    func getIsSelected(for index: Int) -> Bool
    func changeSelection(for index: Int)
    func getDatasourceCount() -> Int
}

protocol MyQotAdminEnvironmentSettingsRouterInterface {
    func dismiss()
}
