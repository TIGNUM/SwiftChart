//
//  GuideFilter.swift
//  QOT
//
//  Created by Sam Wyndham on 21/12/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

struct GuideTransformer {

    func days<T: Sequence>(from guides: T) -> [Guide.Day] where T.Element: RealmGuide {
        let allDays = guides.map { Guide.Day(day: $0) }.reversed()
        var lastThreeDays = [Guide.Day]()

        for day in allDays where lastThreeDays.count < 3 {
            lastThreeDays.append(day)
        }
        return lastThreeDays
    }
}

private extension Guide.Day {

    init(day: RealmGuide) {
        if day.createdAt.isSameDay(guideDate) {
            let items = day.items.filter { (guideItem) -> Bool in
                let calendar = Calendar.current
                if let displayTime = guideItem.referencedItem?.displayTime {
                    let hour = displayTime.hour
                    let minute = displayTime.minute
                    let now = guideDate
                    if let minDisplayDate = calendar.date(bySettingHour: hour, minute: minute, second: 0, of: now) {
                        return now > minDisplayDate
                    } else {
                        return true // Still show item if displayTime is malformed
                    }
                } else {
                    return true
                }
            }
            self.items = items.flatMap { Guide.Item(item: $0) }
            self.createdAt = day.createdAt
        } else {
            self.items = day.items.flatMap { Guide.Item(item: $0) }
            self.createdAt = day.createdAt
        }
    }
}

private extension Guide.Item {

    init?(item: RealmGuideItem) {
        if let learn = item.guideItemLearn {
            status = learn.completedAt == nil ? .todo : .done
            title = learn.title
            content = .text(learn.body)
            subtitle = learn.displayType ?? ""
            type = learn.type
            link = .path(learn.link)
            featureLink = .path(learn.featureLink ?? "")
            featureButton = learn.featureButton
            identifier = item.localID
            notificationID = learn.localID
            dailyPrep = nil
            greeting = learn.greeting
            createdAt = learn.createdAt
        } else if let notification = item.guideItemNotification {
            status = notification.completedAt == nil ? .todo : .done
            title = notification.title ?? ""
            content = .text(notification.body)
            subtitle = notification.displayType
            type = notification.type
            link = .path(notification.link)
            featureLink = nil
            featureButton = nil
            identifier = item.localID
            notificationID = notification.localID
            dailyPrep = DailyPrep(feedback: notification.morningInterviewFeedback,
                                  results: Array(notification.dailyPrepResults.map { String(format: "%d", $0.value) }))
            greeting = notification.greeting
            createdAt = notification.createdAt
        } else {
            return nil
        }
    }
}
