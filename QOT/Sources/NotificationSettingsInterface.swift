//
//  NotificationSettingsInterface.swift
//  QOT
//
//  Created by Anais Plancoulaine on 03.02.21.
//  Copyright (c) 2021 Tignum. All rights reserved.
//

import Foundation

protocol NotificationSettingsViewControllerInterface: class {
    func setupView()
}

protocol NotificationSettingsPresenterInterface {
    func setupView()
}

protocol NotificationSettingsInteractorInterface: Interactor {}

protocol NotificationSettingsRouterInterface {
    func dismiss()
}
