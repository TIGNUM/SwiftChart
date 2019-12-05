//
//  QDMGuideItemNotification+UserNotifications.swift
//  QOT
//
//  Created by Sanggeon Park on 22.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import UserNotifications

import qot_dal

extension QDMGuideItemNotification {

    enum ItemType: String {
        case morningInterview = "MORNING_INTERVIEW"
        case morningInterviewReminder = "MORNING_INTERVIEW_REMINDER"
        case weeklyInterview = "WEEKLY_INTERVIEW"
        case toBeVision = "TOBEVISION"
        case randomContentSleep = "RANDOM_CONTENT_SLEEP"
        case randomContentMovement = "RANDOM_CONTENT_MOVEMENT"
        case fitBitSyncReminder = "FITBIT_SYNC_REMINDER"
    }

    var isDailyPrep: Bool {
        guard let itemType = ItemType(rawValue: type ?? "") else { return false }
        return itemType == .morningInterview || itemType == .weeklyInterview
    }

    var notificationIdentifier: String {
        return QDMGuideItemNotification.notificationIdentifier(with: type, date: localNotificationDate, link: link)
    }

    var notificationRequest: UNNotificationRequest? {
        guard let triggerDate = localNotificationDate, isDailyPrep == false else { return nil }
        let content = UNMutableNotificationContent(title: title, body: body ?? "", soundName: sound, link: link ?? "")
        let trigger = UNCalendarNotificationTrigger(localTriggerDate: triggerDate)
        return UNNotificationRequest(identifier: notificationIdentifier, content: content, trigger: trigger)
    }
}
