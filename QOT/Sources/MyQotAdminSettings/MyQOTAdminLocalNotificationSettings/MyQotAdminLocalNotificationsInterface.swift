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

protocol MyQotAdminLocalNotificationsInteractorInterface: Interactor {
    func getHeaderTitle() -> String
    func getNotificationTitle() -> String
    func getTitle(at index: Int) -> String
    func getSubtitle(at index: Int) -> String
    func getDatasourceCount() -> Int
    func scheduleNotification(title: String,
                              body: String,
                              link: String,
                              completionHandler: @escaping () -> Void) 
}

protocol MyQotAdminLocalNotificationsRouterInterface {
    func dismiss()
}
