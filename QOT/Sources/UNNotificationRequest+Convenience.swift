//
//  UNNotificationRequest+Convenience.swift
//  QOT
//
//  Created by Sam Wyndham on 29/01/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation
import UserNotifications

extension UNNotificationRequest {

    func nextTriggerDate() -> Date? {
        if let trigger = trigger as? UNCalendarNotificationTrigger {
            return trigger.nextTriggerDate()
        } else if let trigger = trigger as? UNTimeIntervalNotificationTrigger {
            return trigger.nextTriggerDate()
        } else {
            return nil
        }
    }
}
