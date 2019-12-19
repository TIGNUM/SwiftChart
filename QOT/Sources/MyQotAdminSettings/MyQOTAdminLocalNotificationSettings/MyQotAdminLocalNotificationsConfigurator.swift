//
//  MyQotAdminLocalNotificationsConfigurator.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 12/12/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

final class MyQotAdminLocalNotificationsConfigurator {
    static func configure(viewController: MyQotAdminLocalNotificationsViewController) {
        let presenter = MyQotAdminLocalNotificationsPresenter(viewController: viewController)
        let interactor = MyQotAdminLocalNotificationsInteractor(presenter: presenter)
        viewController.interactor = interactor
    }
}
