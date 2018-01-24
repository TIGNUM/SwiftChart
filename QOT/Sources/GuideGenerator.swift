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

protocol GuideItemFactoryProtocol {

    func makeItem(with item: GuideLearnItem) -> Guide.Item?
    func makeItem(with item: GuideNotificationItem) -> Guide.Item?
    func makeMessageText(with greeting: Guide.Message) -> String
    func userName() -> String?
}

struct GuideGenerator {

    let localCalendar: Calendar
    let maxDays: Int
    let factory: GuideItemFactoryProtocol

    init(localCalendar: Calendar = Calendar.current, maxDays: Int, factory: GuideItemFactoryProtocol) {
        self.localCalendar = localCalendar
        self.maxDays = maxDays
        self.factory = factory
    }

    func generateGuide(notificationItems: [GuideNotificationItem],
                       featureItems: [GuideLearnItem],
                       strategyItems: [GuideLearnItem],
                       now: Date = Date()) throws -> Guide.Model {
        guard maxDays > 0 else { throw SimpleError(localizedDescription: "Incorrect maxDays: \(maxDays)") }

        let minDate = now.addingTimeInterval(-TimeInterval(days: maxDays - 1))
        let todaylocalStartOfDay = localCalendar.startOfDay(for: now)
        var days: [Date: Day] = [:]

        addNotificationItems(from: notificationItems, to: &days, now: now, minDate: minDate)
        addCompleteLearnItems(from: featureItems, to: &days, minDate: minDate, now: now)
        addIncompleteLearnItems(from: featureItems, to: &days, todayLocalStartOfDay: todaylocalStartOfDay)
        addCompleteLearnItems(from: strategyItems, to: &days, minDate: minDate, now: now)
        addIncompleteLearnItems(from: strategyItems, to: &days, todayLocalStartOfDay: todaylocalStartOfDay)

        let guideDays: [Date: Guide.Day] = days.mapKeyValues { ($0, guideDayBySortingItems(from: $1)) }
        let sortedDays = guideDays.sorted { $0.key > $1.key }.map { $0.value }

        // Message
        let message = guideMessage(today: guideDays[todaylocalStartOfDay],
                                   featureItems: featureItems,
                                   strategyItems: strategyItems,
                                   notificationitems: notificationItems)

        return Guide.Model(days: sortedDays,
                               greeting: greeting(userName: factory.userName(), now: now),
                               message: factory.makeMessageText(with: message))
    }

    private func guideMessage(today: Guide.Day?,
                              featureItems: [GuideLearnItem],
                              strategyItems: [GuideLearnItem],
                              notificationitems: [GuideNotificationItem]) -> Guide.Message {

        // FIXME: Discuss logic with Dan
        var learnItems = featureItems
        learnItems.append(contentsOf: strategyItems)

        if let today = today, today.hasIncompleteDailyPrep == true {
            return .dailyPrep
        }

        if learnItems.areAllComplete == true {
            return .guideAllCompleted
        }

        if learnItems.areAllIncomplete {
            return .welcome
        }

        if let today = today, today.items.areAllComplete {
            return .guideTodayCompleted
        }

        return .dailyLearnPlan
    }

    private func greeting(userName: String?, now: Date) -> String {
        let isBeforNoon = localCalendar.component(.hour, from: now) <= 12
        let userName = userName ?? "High Performer"
        let welcomeText = isBeforNoon ? "Good Morning" : "Hello"
        return "\(welcomeText) \(userName),"
    }
}

private extension GuideGenerator {

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
            days.appendItem(item, localStartOfDay: localStartOfDay, factory: factory)
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
            days.appendItem(item, localStartOfDay: todayLocalStartOfDay, factory: factory)
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
            if let completedAt = item.completedAt, item.displayAt != nil {
                guard completedAt >= minDate, completedAt <= now else { continue }

                let localStartOfDay = localCalendar.startOfDay(for: completedAt)
                days.appendItem(item, localStartOfDay: localStartOfDay, factory: factory)
            }
        }

    }

    /**
     Returns a `Guide.Day` from `day, sorting items.
     - `Item`s are sorted by:
     1. `displayHour` - ascending,
     2. `displayMinute` - ascending,
     3. `priority` - decending
     4. `id` - used just to make the function deterministic.
     */
    func guideDayBySortingItems(from day: Day) -> Guide.Day {
        let sortedItems = day.items.sorted {
            if $0.sort.displayHour != $1.sort.displayHour {
                return $0.sort.displayHour < $1.sort.displayHour
            } else if $0.sort.displayMinute != $1.sort.displayMinute {
                return $0.sort.displayMinute < $1.sort.displayMinute
            } else if $0.sort.priority != $1.sort.priority {
                return $0.sort.priority > $1.sort.priority
            } else {
                return $0.sort.id > $1.sort.id
            }
            }.map { $0.item }
        return Guide.Day(items: sortedItems, localStartOfDay: day.localStartOfDay)
    }
}

private extension GuideGenerator {

    struct Day {
        let localStartOfDay: Date
        var items: [(item: Guide.Item, sort: ItemSort)]
    }

    struct ItemSort {
        let displayHour: Int
        let displayMinute: Int
        let priority: Int
        let id: String
    }
}

private extension Dictionary where Key == Date, Value == GuideGenerator.Day {

    mutating func appendItem(_ item: GuideLearnItem, localStartOfDay: Date, factory: GuideItemFactoryProtocol) {
        guard let guideItem = factory.makeItem(with: item), let displayAt = item.displayAt else { return }

        appendItem(guideItem,
                   hour: displayAt.hour,
                   minute: displayAt.minute,
                   priority: item.priority,
                   localStartOfDay: localStartOfDay)
    }

    mutating func appendItem(_ item: GuideNotificationItem, localStartOfDay: Date, factory: GuideItemFactoryProtocol) {
        guard let guideItem = factory.makeItem(with: item), let displayAt = item.displayAt else { return }

        appendItem(guideItem,
                   hour: displayAt.hour,
                   minute: displayAt.minute,
                   priority: item.priority,
                   localStartOfDay: localStartOfDay)
    }

    mutating func appendItem(_ item: Guide.Item, hour: Int, minute: Int, priority: Int, localStartOfDay: Date) {
        let id = item.identifier
        let sort = GuideGenerator.ItemSort(displayHour: hour, displayMinute: minute, priority: priority, id: id)
        if var day = self[localStartOfDay] {
            day.items.append((item, sort))
            self[localStartOfDay] = day
        } else {
            self[localStartOfDay] = GuideGenerator.Day(localStartOfDay: localStartOfDay, items: [(item, sort)])
        }
    }
}

private extension Guide.Day {

    var hasIncompleteDailyPrep: Bool {
        return items.filter { $0.isDailyPrep == true && $0.isDailyPrepCompleted == false }.count > 0
    }
}

private extension Array where Element == Guide.Item {

    var areAllComplete: Bool {
        return filter { $0.status == .done }.count == 0
    }
}

private extension Array where Element == GuideLearnItem {

    var areAllComplete: Bool {
        return filter { $0.completedAt == nil }.count == 0
    }

    var areAllIncomplete: Bool {
        return filter { $0.completedAt != nil }.count == 0
    }
}
