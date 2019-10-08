//
//  SubsriptionReminderRouter.swift
//  QOT
//
//  Created by karmic on 28.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class SubsriptionReminderRouter {

    // MARK: - Properties

    private let windowManager: WindowManager
    private weak var viewController: (SubsriptionReminderViewController & UIViewControllerInterface)?
    lazy var showSigningInfoViewNotificationHandler = NotificationHandler(name: .showSigningInfoView)

    // MARK: - Init

    init(windowManager: WindowManager, viewController: SubsriptionReminderViewController & UIViewControllerInterface) {
        self.windowManager = windowManager
        self.viewController = viewController
        showSigningInfoViewNotificationHandler.handler = { [weak self] (_: Notification) in
            self?.dismiss()
        }
    }
}

// MARK: - SubsriptionReminderRouterInterface

extension SubsriptionReminderRouter: SubsriptionReminderRouterInterface {
    func dismiss() {
        viewController?.dismiss(animated: true) { [weak self] in
            self?.windowManager.resignWindow(atLevel: .priority)
        }
    }

    func showLogoutDialog() {
        let cancel = QOTAlertAction(title: ScreenTitleService.main.localizedString(for: .ButtonTitleCancel))
        let logout = QOTAlertAction(title: AppTextService.get(AppTextKey.subscription_reminder_view_logout_button)) { (_) in
            qot_dal.SessionService.main.logout()
        }
        QOTAlert.show(title: nil, message: R.string.localized.alertMessageLogout(), bottomItems: [cancel, logout])
    }
}
