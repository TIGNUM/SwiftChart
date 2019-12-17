//
//  MyQotAdminLocalNotificationsInterface.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 12/12/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

protocol MyQotAdminLocalNotificationsViewControllerInterface: class {
    func setupView()
}

protocol MyQotAdminLocalNotificationsPresenterInterface {
    func setupView()
}

protocol MyQotAdminLocalNotificationsInteractorInterface: Interactor {}

protocol MyQotAdminLocalNotificationsRouterInterface {
    func dismiss()
}
