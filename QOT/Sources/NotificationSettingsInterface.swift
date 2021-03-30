//
//  NotificationSettingsInterface.swift
//  QOT
//
//  Created by Anais Plancoulaine on 03.02.21.
//  Copyright (c) 2021 Tignum. All rights reserved.
//

import Foundation

protocol NotificationSettingsViewControllerInterface: class {
    func setup()
}

protocol NotificationSettingsPresenterInterface {
    func present()
}

protocol NotificationSettingsInteractorInterface: Interactor {
    var notificationsTitle: String { get }
    var notificationsSubtitle: String { get }
    func handleTap(setting: NotificationSettingsModel.Setting)
}

protocol NotificationSettingsRouterInterface {
    func dismiss()
    func didTapDailyReminders()
}
