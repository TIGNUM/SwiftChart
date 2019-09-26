//
//  PaymentReminderRouter.swift
//  QOT
//
//  Created by Anais Plancoulaine on 17.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class PaymentReminderRouter {

    // MARK: - Properties

    private weak var viewController: (PaymentReminderViewController & UIViewControllerInterface)?
    lazy var showSigningInfoViewNotificationHandler = NotificationHandler(name: .showSigningInfoView)

    // MARK: - Init

    init(viewController: PaymentReminderViewController & UIViewControllerInterface) {
        self.viewController = viewController
        showSigningInfoViewNotificationHandler.handler = { [weak self] (_: Notification) in
            self?.dismiss()
        }
    }
}

// MARK: - PaymentReminderRouterInterface

extension PaymentReminderRouter: PaymentReminderRouterInterface {
    func dismiss() {
        viewController?.dismiss(animated: true)
    }

    func showLogoutDialog() {
        let cancel = QOTAlertAction(title: ScreenTitleService.main.localizedString(for: .ButtonTitleCancel))
        let logout = QOTAlertAction(title: R.string.localized.sidebarTitleLogout()) { (_) in
            SessionService.main.logout()
            ExtensionsDataManager.didUserLogIn(false)
            UIApplication.shared.shortcutItems?.removeAll()
        }
        QOTAlert.show(title: nil, message: R.string.localized.alertMessageLogout(), bottomItems: [cancel, logout])
    }
}
