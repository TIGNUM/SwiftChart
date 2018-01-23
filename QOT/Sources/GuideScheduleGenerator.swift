//
//  GuideGenerator.swift
//  QOT
//
//  Created by Sam Wyndham on 18/01/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

protocol GuideNotificationItem {

    var localID: String { get }
    var type: String { get }
    var completedAt: Date? { get }
    var displayAt: (utcDate: Date, hour: Int, minute: Int)? { get }
    var priority: Int { get }
}

protocol GuideLearnItem {

    var localID: String { get }
    var type: String { get }
    var completedAt: Date? { get }
    var displayAt: (hour: Int, minute: Int)? { get }
    var block: Int { get }
    var priority: Int { get }
}

struct GuideScheduleGenerator {

    let localCalendar: Calendar
    let maxDays: Int

    init(localCalendar: Calendar = Calendar.current, maxDays: Int) {
        self.localCalendar = localCalendar
        self.maxDays = maxDays
    }

    func generateSchedule(notificationItems: [GuideNotificationItem],
                          featureItems: [GuideLearnItem],
                          strategyItems: [GuideLearnItem],
                          now: Date = Date()) -> [Day] {
        guard maxDays > 0 else { return [] }

        let minDate = now.addingTimeInterval(-TimeInterval(days: maxDays - 1))
        let todaylocalStartOfDay = localCalendar.startOfDay(for: now)
        var days: [Date: Day] = [:]

        addNotificationItems(from: notificationItems, to: &days, now: now, minDate: minDate)
        addCompleteLearnItems(from: featureItems, to: &days, minDate: minDate, now: now)
        addIncompleteLearnItems(from: featureItems, to: &days, todayLocalStartOfDay: todaylocalStartOfDay)
        addCompleteLearnItems(from: strategyItems, to: &days, minDate: minDate, now: now)
        addIncompleteLearnItems(from: strategyItems, to: &days, todayLocalStartOfDay: todaylocalStartOfDay)

        return sortedDays(from: days)
    }
}

private extension GuideScheduleGenerator {

    /**
     Adds notifications items to `days` that are between `now` and `minDate`.
    */
    func addNotificationItems(from items: [GuideNotificationItem],
                              to days: inout [Date: Day],
                              now: Date,
                              minDate: Date) {
        let localMinDate = localCalendar.startOfDay(for: minDate)
        for item in items {
            guard
                let displayAt = item.displayAt,
                let localDisplayDate = localCalendar.date(bySettingHour: displayAt.hour,
                                                          minute: displayAt.minute,
                                                          second: 0,
                                                          of: displayAt.utcDate),
                localDisplayDate <= now,
                localDisplayDate >= localMinDate
                else { continue }

            let localStartOfDay = localCalendar.startOfDay(for: displayAt.utcDate)
            let scheduleItem = Item(id: item.localID,
                                    type: item.type,
                                    displayHour: displayAt.hour,
                                    displayMinute: displayAt.minute,
                                    priority: item.priority)
            days.appendItem(scheduleItem, localStartOfDay: localStartOfDay)
        }
    }

    /**
     Adds imcomplete learn items to `days`.
     - Items are added to today's `Day` only.
     - Added items have the same block - the lowest incomplete block.
    */
    func addIncompleteLearnItems(from learnItems: [GuideLearnItem],
                                         to days: inout [Date: Day],
                                         todayLocalStartOfDay: Date) {
        guard let block = todaysBlockIndex(for: learnItems,
                                           todayLocalStartOfDay: todayLocalStartOfDay) else { return }

        let items = learnItems.filter {
            $0.block == block && $0.completedAt == nil && $0.displayAt != nil
        }
        for item in items {
            let displayAt = item.displayAt! // We have filtered items with no displayAt out above so safe.
            let scheduleItem = Item(id: item.localID,
                                    type: item.type,
                                    displayHour: displayAt.hour,
                                    displayMinute: displayAt.minute,
                                    priority: item.priority)
            days.appendItem(scheduleItem, localStartOfDay: todayLocalStartOfDay)
        }
    }

    /**
     Returns the lowest block of an item that is completed today or not completed
    */
    func todaysBlockIndex(for learnItems: [GuideLearnItem], todayLocalStartOfDay: Date) -> Int? {
        var candidate: Int?
        for item in learnItems {
            if let existingCandidate = candidate, existingCandidate <= item.block {
                continue
            }
            if let completedAt =  item.completedAt {
                let localCompletedAt = localCalendar.startOfDay(for: completedAt)
                if localCompletedAt == todayLocalStartOfDay {
                    candidate = item.block
                }
            } else {
                candidate = item.block
            }
        }
        return candidate
    }

    /**
     Adds complete learn items to `days` that are between `now` and `minDate`.
     */
    func addCompleteLearnItems(from learnItems: [GuideLearnItem],
                               to days: inout [Date: Day],
                               minDate: Date,
                               now: Date) {
        for item in learnItems {
            if let completedAt = item.completedAt, let displayAt = item.displayAt {
                guard completedAt >= minDate, completedAt <= now else { continue }

                let localStartOfDay = localCalendar.startOfDay(for: completedAt)
                let scheduleItem = Item(id: item.localID,
                                        type: item.type,
                                        displayHour: displayAt.hour,
                                        displayMinute: displayAt.minute,
                                        priority: item.priority)
                days.appendItem(scheduleItem, localStartOfDay: localStartOfDay)
            }
        }

    }


    /**
     Returns array of sorted `Day`s from `days`.
     - `Day`s are sorted by date, decending.
     - `Item`s are sorted by:
        1. `displayHour` - ascending,
        2. `displayMinute` - ascending,
        3. `priority` - decending
        4. `id` - used just to make the function deterministic.
    */
    func sortedDays(from days: [Date: Day]) -> [Day] {
        var days = days
        for date in days.keys {
            if var day = days[date] {
                day.items = day.items.sorted {
                    if $0.displayHour != $1.displayHour {
                        return $0.displayHour < $1.displayHour
                    } else if $0.displayMinute != $1.displayMinute {
                        return $0.displayMinute < $1.displayMinute
                    } else if $0.priority != $1.priority {
                        return $0.priority > $1.priority
                    } else {
                        return $0.id > $1.id
                    }
                }
                days[date] = day
            }
        }
        return days.sorted { $0.key > $1.key }.map { $0.value }
    }
}

private extension Dictionary where Key == Date, Value == GuideScheduleGenerator.Day {

    mutating func appendItem(_ item: GuideScheduleGenerator.Item, localStartOfDay: Date) {
        if var day = self[localStartOfDay] {
            day.items.append(item)
            self[localStartOfDay] = day
        } else {
            self[localStartOfDay] = GuideScheduleGenerator.Day(localStartOfDay: localStartOfDay, items: [item])
        }
    }
}

extension GuideScheduleGenerator {

    struct Day {
        let localStartOfDay: Date
        var items: [Item]
    }

    struct Item {
        let id: String
        let type: String
        let displayHour: Int
        let displayMinute: Int
        let priority: Int
    }
}
