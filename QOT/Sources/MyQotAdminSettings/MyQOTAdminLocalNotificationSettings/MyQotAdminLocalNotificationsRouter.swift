//
//  MyQotAdminLocalNotificationsRouter.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 12/12/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class MyQotAdminLocalNotificationsRouter {

    // MARK: - Properties
    private weak var viewController: MyQotAdminLocalNotificationsViewController?

    // MARK: - Init
    init(viewController: MyQotAdminLocalNotificationsViewController?) {
        self.viewController = viewController
    }
}

// MARK: - MyQotAdminLocalNotificationsRouterInterface
extension MyQotAdminLocalNotificationsRouter: MyQotAdminLocalNotificationsRouterInterface {
    func dismiss() {
        viewController?.dismiss(animated: true, completion: nil)
    }
}
