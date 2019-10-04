//
//  QDMGuideItemNotfication+UserNotifications.swift
//  QOT
//
//  Created by Sanggeon Park on 22.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import UserNotifications

import qot_dal

extension QDMGuideItemNotfication {

    static func notificationIdentifier(with type: String?, date: Date?, link: String?) -> String {
        let triggerDate = date
        let dateString = triggerDate != nil ? DateFormatter.iso8601UTC.string(from: triggerDate!) : ""
        return "\(type ?? "UNKNOWN")[:]\(dateString)[:]\(link ?? "qot://")"
    }

    enum ItemType: String {
        case morningInterview = "MORNING_INTERVIEW"
        case morningInterviewReminder = "MORNING_INTERVIEW_REMINDER"
        case weeklyInterview = "WEEKLY_INTERVIEW"
        case toBeVision = "TOBEVISION"
        case randomContentSleep = "RANDOM_CONTENT_SLEEP"
        case randomContentMovement = "RANDOM_CONTENT_MOVEMENT"
        case fitBitSyncReminder = "FITBIT_SYNC_REMINDER"
    }

    var localNotificationDate: Date? {
        guard let issueDate = issueDate, let displayTime = displayTime else { return nil }
        return displayTime.date(with: issueDate)
    }
    var isDailyPrep: Bool {
        guard let itemType = ItemType(rawValue: type ?? "") else { return false }
        return itemType == .morningInterview || itemType == .weeklyInterview
    }

    var notificationIdentifier: String {
        return QDMGuideItemNotfication.notificationIdentifier(with: type, date: localNotificationDate, link: link)
    }

    var notificationRequest: UNNotificationRequest? {
        guard let triggerDate = localNotificationDate, isDailyPrep == false else { return nil }
        let content = UNMutableNotificationContent(title: title, body: body ?? "", soundName: sound, link: link ?? "")
        if sound?.isEmpty == true {
            content.sound = nil
        }
        let trigger = UNCalendarNotificationTrigger(localTriggerDate: triggerDate)
        return UNNotificationRequest(identifier: notificationIdentifier, content: content, trigger: trigger)
    }
}
