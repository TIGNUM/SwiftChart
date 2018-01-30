//
//  UNCalendarNotificationTrigger+Convenience.swift
//  QOT
//
//  Created by Sam Wyndham on 29/01/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UserNotifications

extension UNCalendarNotificationTrigger {

    convenience init(localTriggerDate: Date, calendar: Calendar = .current) {
        let componants: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute]
        let triggerComponants = calendar.dateComponents(componants, from: localTriggerDate)
        self.init(dateMatching: triggerComponants, repeats: false)
    }
}
