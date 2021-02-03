//
//  NotificationSettingsConfigurator.swift
//  QOT
//
//  Created by Anais Plancoulaine on 03.02.21.
//  Copyright (c) 2021 Tignum. All rights reserved.
//

import Foundation

final class NotificationSettingsConfigurator {
    static func make() -> (NotificationSettingsViewController) -> Void {
        return { (viewController) in
            let presenter = NotificationSettingsPresenter(viewController: viewController)
            let interactor = NotificationSettingsInteractor(presenter: presenter)
            viewController.interactor = interactor
        }
    }
}
