//
//  SettingsProtocols.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 26/04/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

protocol SettingsViewControllerInterface: class {
    func setup(_ settings: SettingsModel)
}

protocol SettingsPresenterInterface {
    func present(_ settings: SettingsModel)
}

protocol SettingsInteractorInterface: Interactor {
    func handleTap(setting: SettingsModel.Setting)
}

protocol SettingsRouterInterface {
    func handleTap(setting: SettingsModel.Setting)
}
