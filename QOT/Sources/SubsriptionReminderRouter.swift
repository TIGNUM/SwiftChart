//
//  SubsriptionReminderRouter.swift
//  QOT
//
//  Created by karmic on 28.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class SubsriptionReminderRouter {

    // MARK: - Properties

    private let windowManager: WindowManager
    private weak var viewController: (SubsriptionReminderViewController & UIViewControllerInterface)?

    // MARK: - Init

    init(windowManager: WindowManager, viewController: SubsriptionReminderViewController & UIViewControllerInterface) {
        self.windowManager = windowManager
        self.viewController = viewController
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
        viewController?.showAlert(type: .logout, handlerDestructive: { [weak self] in
            ExtensionsDataManager.didUserLogIn(false)
            UIApplication.shared.shortcutItems?.removeAll()
            NotificationHandler.postNotification(withName: .logoutNotification)
            self?.dismiss()
        })
    }
}
