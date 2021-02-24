//
//  DailyCheckInLocalNotificationConfig.swift
//  QOT
//
//  Created by Sanggeon Park on 12/02/2020.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UserNotifications
import qot_dal

let DAILY_CHECK_IN_NOTIFICATION_IDENTIFIER = "daily-check-in-no-sound"

struct DailyCheckInLocalNotificationConfig: Codable {
    let version: Int
    let hour: Int
    let minute: Int
    let weekday: Int /// 1 (Sunday) ~ 7 (Saturday)
    let soundName: String?
    let titleKey: String
    let link: String
    let bodyContentItemIds: [Int]
    let description: String?
    var bodyStrings: [String]?

    init(weekday: Int) {
        version = 0
        hour = 5
        minute = 0
        self.weekday = weekday
        soundName = nil
        titleKey = "generic.local_notification.daily_check_in.default_title"
        link = URLScheme.dailyCheckIn.launchPathWithParameterValue(String.empty)
        bodyContentItemIds = [107606, 107607, 107608, 107609, 107610, 107611, 107612, 107613, 107614, 107615,
                              107616, 107617, 107618, 107619, 107620, 107621]
        description = nil
    }

    func identifier() -> String {
        return "\(DAILY_CHECK_IN_NOTIFICATION_IDENTIFIER)[:]\(version)[:]\(soundName ?? "silent")[:]\(titleKey)[:]\(weekday)[:]\(hour)[:]\(minute)[:]\(link)"
    }

    func notificationRequest(with body: String) -> UNNotificationRequest {
        let componants = DateComponents(hour: hour, minute: minute, weekday: weekday)
        let title = AppTextService.get(AppTextKey(titleKey))
        let content = UNMutableNotificationContent(title: title, body: body, soundName: soundName ?? String.empty, link: link)
        if soundName == nil || soundName?.isEmpty == true {
            content.sound = .none
        }
        let trigger = UNCalendarNotificationTrigger(dateMatching: componants, repeats: true)
        return UNNotificationRequest(identifier: identifier(), content: content, trigger: trigger)
    }
}

func scheduleDailycheckInNotification(config: DailyCheckInLocalNotificationConfig) {
    let defaultBody = AppTextService.get(.generic_local_notification_daily_check_in_default_message)
    ContentService.main.getContentItemsByIds(config.bodyContentItemIds) { (items) in
        let body = items?.randomElement()?.valueText ?? defaultBody
        let request = config.notificationRequest(with: body)
        UNUserNotificationCenter.current().add(request) { (error) in
            guard error == nil else {
                log("Failed to schedule dailyCheckin notification request: \(request), error: \(error!)")
                return
            }
        }
        NotificationService.main.reportScheduledLocalNotification(identifier: nil,
                                                                  internalNotificationIdentifier: config.identifier(),
                                                                  link: config.link) { (_) in /* WOW */ }
    }
}
