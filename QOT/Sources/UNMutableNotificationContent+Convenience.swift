//
//  UNMutableNotificationContent+Convenience.swift
//  QOT
//
//  Created by Sam Wyndham on 29/01/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UserNotifications

extension UNMutableNotificationContent {

    convenience init(title: String?, body: String, soundName: String?, link: String) {
        self.init()
        title.map { self.title = $0 }
        self.body = body
        self.sound = soundName.map { UNNotificationSound(named: $0) }
        self.userInfo = ["link": link]
    }
}
