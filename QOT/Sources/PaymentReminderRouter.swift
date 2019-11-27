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
        let cancel = QOTAlertAction(title: AppTextService.get(AppTextKey.generic_view_button_cancel))
        let logout = QOTAlertAction(title: AppTextService.get(AppTextKey.generic_payment_screen_section_footer_button_switch_account)) { (_) in
            SessionService.main.logout()
            ExtensionsDataManager.didUserLogIn(false)
            UIApplication.shared.shortcutItems?.removeAll()
        }
        QOTAlert.show(title: nil, message: AppTextService.get(AppTextKey.generic_payment_screen_alert_log_out_body_logout), bottomItems: [cancel, logout])
    }
}
