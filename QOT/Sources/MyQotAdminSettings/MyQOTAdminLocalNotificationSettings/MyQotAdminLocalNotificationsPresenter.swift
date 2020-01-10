//
//  MyQotAdminLocalNotificationsPresenter.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 12/12/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class MyQotAdminLocalNotificationsPresenter {

    // MARK: - Properties
    private weak var viewController: MyQotAdminLocalNotificationsViewControllerInterface?

    // MARK: - Init
    init(viewController: MyQotAdminLocalNotificationsViewControllerInterface?) {
        self.viewController = viewController
    }
}

// MARK: - MyQotAdminLocalNotificationsInterface
extension MyQotAdminLocalNotificationsPresenter: MyQotAdminLocalNotificationsPresenterInterface {
    func setupView() {
        viewController?.setupView()
    }
}
