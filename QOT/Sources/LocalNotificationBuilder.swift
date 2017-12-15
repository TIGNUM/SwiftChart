//
//  LocalNotificationBuilder.swift
//  QOT
//
//  Created by karmic on 15.12.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UserNotifications

struct LocalNotificationBuilder {

    private let center = UNUserNotificationCenter.current()

    func create(_ items: [GuideItemNotification]) {
        items.forEach { (item: GuideItemNotification) in
            let content = UNMutableNotificationContent()
            if let title = item.title {
                content.title = title
            }
            content.body = item.body
            content.sound = UNNotificationSound(named: item.sound)

            let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second,],
                                                              from: item.issueDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate,
                                                                      repeats: false)

            let identifier = "QOTLocalNotification"
            let request = UNNotificationRequest(identifier: identifier,
                                                content: content,
                                                trigger: trigger)

            center.add(request) { (error) in
                if let error = error {
                    log(error, level: .error)
                }
            }
        }
    }
}
