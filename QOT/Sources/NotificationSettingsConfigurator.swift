//
//  NotificationSettingsConfigurator.swift
//  QOT
//
//  Created by Anais Plancoulaine on 03.02.21.
//  Copyright (c) 2021 Tignum. All rights reserved.
//

import Foundation

final class NotificationSettingsConfigurator {
    static func make(viewController: NotificationSettingsViewController) {
        let router = NotificationSettingsRouter(viewController: viewController)
        let presenter = NotificationSettingsPresenter(viewController: viewController)
        let interactor = NotificationSettingsInteractor(presenter: presenter, router: router)
        viewController.interactor = interactor
    }
}
