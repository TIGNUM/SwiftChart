//
//  NotificationTokenHandler.swift
//  QOT
//
//  Created by Lee Arromba on 14/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import RealmSwift

class NotificationTokenHandler {
    private let notificationToken: NotificationToken
    private let notificationHandler: NotificationHandler

    init(notificationToken: NotificationToken) {
        self.notificationToken = notificationToken
        notificationHandler = NotificationHandler(name: .logoutNotification)
        notificationHandler.handler = { [weak self] (_: Notification) in
            self?.stop()
        }
    }

    deinit {
        stop()
    }

    func stop() {
        notificationToken.invalidate()
    }
}
