//
//  NotificationSettingsInterface.swift
//  QOT
//
//  Created by Anais Plancoulaine on 03.02.21.
//  Copyright (c) 2021 Tignum. All rights reserved.
//

import Foundation

protocol NotificationSettingsViewControllerInterface: class {
    func setup(_ notification: NotificationSettingsModel)
}

protocol NotificationSettingsPresenterInterface {
    func present(_ notification: NotificationSettingsModel)
}

protocol NotificationSettingsInteractorInterface: Interactor {}

protocol NotificationSettingsRouterInterface {
    func dismiss()
}
