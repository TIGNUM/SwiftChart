//
//  NotificationConfigurationObject.swift
//  QOT
//
//  Created by Sam Wyndham on 14/03/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UserNotifications

let DAILY_CHECK_IN_NOTIFICATION_IDENTIFIER = "daily-check-in-no-sound"
// FIXME: Make realm obj and sync from server
struct NotificationConfigurationObject {

    let localID: String
    let minute: Int
    let hour: Int
    let weekday: Int /// 1 (Sunday) ~ 7 (Saturday)
    let title: String
    let body: String
    let link: String

    private init(localID: String, minute: Int, hour: Int, weekday: Int, title: String, body: String, link: String) {
        self.localID = localID
        self.minute = minute
        self.hour = hour
        self.weekday = weekday
        self.title = title
        self.body = body
        self.link = link
    }

    private var notificationRequest: UNNotificationRequest {
        let componants = DateComponents(hour: hour, minute: minute, weekday: weekday)
        let content = UNMutableNotificationContent(title: title, body: body, soundName: "", link: link)
        content.sound = .none
        let trigger = UNCalendarNotificationTrigger(dateMatching: componants, repeats: true)
        let identifier = "\(DAILY_CHECK_IN_NOTIFICATION_IDENTIFIER)-\(weekday)"
        return UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
    }
}

extension NotificationConfigurationObject {

    static func scheduleDailyNotificationsIfNeeded() {
        NotificationConfigurationObject.needsSchedule { (isNeeded) in
            if isNeeded {
                NotificationConfigurationObject.all().forEach {
                    UNUserNotificationCenter.current().add( $0.notificationRequest)
                }
            }
        }
    }

    private static func needsSchedule(completion: ((Bool) -> Void)?) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            completion?(requests.filter { $0.identifier.hasPrefix(DAILY_CHECK_IN_NOTIFICATION_IDENTIFIER) }.count != 7)
        }
    }

    // FIXME: These should be defined on the server. For now we hard code them.
    static func all() -> [NotificationConfigurationObject] {
        return [
            morningInterview(localID: "sunday", weekday: 1),
            morningInterview(localID: "monday", weekday: 2),
            morningInterview(localID: "tuesday", weekday: 3),
            morningInterview(localID: "wednesday", weekday: 4),
            morningInterview(localID: "thursday", weekday: 5),
            morningInterview(localID: "friday", weekday: 6),
            morningInterview(localID: "saturday", weekday: 7)
        ]
    }

    private static func morningInterview(localID: String, weekday: Int) -> NotificationConfigurationObject {
        return NotificationConfigurationObject(
            localID: localID,
            minute: 0,
            hour: 5,
            weekday: weekday,
            title: "DAILY CHECK IN", // CHANGE ME : USE Screen Title Service
            body: "Let's start the morning with a quick check in, so I can help support you today.",
            link: URLScheme.dailyCheckIn.launchPathWithParameterValue("")
        )
    }
}
