//
//  NotificationSettingsPresenter.swift
//  QOT
//
//  Created by Anais Plancoulaine on 03.02.21.
//  Copyright (c) 2021 Tignum. All rights reserved.
//

import UIKit

final class NotificationSettingsPresenter {

    // MARK: - Properties
    private weak var viewController: NotificationSettingsViewControllerInterface?

    // MARK: - Init
    init(viewController: NotificationSettingsViewControllerInterface?) {
        self.viewController = viewController
    }
}

// MARK: - NotificationSettingsInterface
extension NotificationSettingsPresenter: NotificationSettingsPresenterInterface {
    func present() {
        viewController?.setup()
    }
}
