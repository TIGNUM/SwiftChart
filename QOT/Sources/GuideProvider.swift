//
//  GuideProvider.swift
//  QOT
//
//  Created by Sam Wyndham on 19/01/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

extension Preparation: GuidePreparation {

    var eventStartDate: Date? {
        return self.calendarEvent()?.startDate
    }

    var priority: Int {
        return 9999 // FIXME: Dont hard code
    }
}

extension RealmGuideItemNotification: GuideNotificationItem {

    var displayAt: (utcDate: Date, hour: Int, minute: Int)? {
        guard let utcDate = issueDate, let hour = displayTime?.hour, let minute = displayTime?.minute else {
            return nil
        }
        return (utcDate: utcDate, hour: hour, minute: minute)
    }
}

extension RealmGuideItemLearn: GuideLearnItem {

    var displayAt: (hour: Int, minute: Int)? {
        guard let hour = displayTime?.hour, let minute = displayTime?.minute else {
            return nil
        }
        return (hour: hour, minute: minute)
    }
}

extension NotificationConfigurationObject: GuideNotificationConfiguration {

    var displayAt: (weekday: Int, hour: Int, minute: Int) {
        return (weekday, hour, minute)
    }

    var priority: Int {
        return 10000 // FIXME: Dont hard code
    }
}

extension DailyPrepResultObject: GuideDailyPrepResult {

    var displayAt: (date: ISODate, hour: Int, minute: Int)? {
        guard let date = ISODate(string: isoDate) else { return nil }

        // FIXME: Dont hard code hour and minute
        return (date: date, hour: 5, minute: 0)
    }

    var priority: Int {
        return 10000 // FIXME: Dont hard code
    }
}
