//
//  PaymentReminderRouter.swift
//  QOT
//
//  Created by Anais Plancoulaine on 17.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class PaymentReminderRouter {

    // MARK: - Properties

    private let windowManager: WindowManager
    private weak var viewController: (PaymentReminderViewController & UIViewControllerInterface)?
    lazy var showSigningInfoViewNotificationHandler = NotificationHandler(name: .showSigningInfoView)

    // MARK: - Init

    init(windowManager: WindowManager, viewController: PaymentReminderViewController & UIViewControllerInterface) {
        self.windowManager = windowManager
        self.viewController = viewController
        showSigningInfoViewNotificationHandler.handler = { [weak self] (_: Notification) in
            self?.dismiss()
        }
    }
}

// MARK: - PaymentReminderRouterInterface

extension PaymentReminderRouter: PaymentReminderRouterInterface {
    func dismiss() {
        viewController?.dismiss(animated: true) { [weak self] in
            self?.windowManager.resignWindow(atLevel: .priority)
        }
    }

    func showLogoutDialog() {
        viewController?.showAlert(type: .logout, handlerDestructive: {
            ExtensionsDataManager.didUserLogIn(false)
            UIApplication.shared.shortcutItems?.removeAll()
            NotificationHandler.postNotification(withName: .logoutNotification)
        })
    }
}
