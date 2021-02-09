//
//  NotificationSettingsRouter.swift
//  QOT
//
//  Created by Anais Plancoulaine on 03.02.21.
//  Copyright (c) 2021 Tignum. All rights reserved.
//

import UIKit

final class NotificationSettingsRouter {

    // MARK: - Properties
    private weak var viewController: NotificationSettingsViewController?

    // MARK: - Init
    init(viewController: NotificationSettingsViewController?) {
        self.viewController = viewController
    }
}

// MARK: - NotificationSettingsRouterInterface
extension NotificationSettingsRouter: NotificationSettingsRouterInterface {
    func dismiss() {
        viewController?.dismiss(animated: true, completion: nil)
    }

    func didTapDailyReminders() {
        viewController?.performSegue(withIdentifier: R.segue.notificationSettingsViewController.myQotDailyRemindersSegueIdentifier, sender: nil)
    }
}
