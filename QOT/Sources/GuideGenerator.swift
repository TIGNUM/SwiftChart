//
//  GuideGenerator.swift
//  QOT
//
//  Created by Sam Wyndham on 18/01/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

protocol GuidePreparation {

    var localID: String { get }
    var eventStartDate: Date? { get }
    var priority: Int { get }
}

protocol GuideNotificationConfiguration {

    var localID: String { get }
    var displayAt: (weekday: Int, hour: Int, minute: Int) { get }
    var priority: Int { get }
}

protocol GuideDailyPrepResult {

    var localID: String { get }
    var displayAt: (date: ISODate, hour: Int, minute: Int)? { get }
    var priority: Int { get }
}

protocol GuideNotificationItem {

    var localID: String { get }
    var displayAt: (utcDate: Date, hour: Int, minute: Int)? { get }
    var priority: Int { get }
}

protocol GuideLearnItem {

    var localID: String { get }
    var completedAt: Date? { get }
    var displayAt: (hour: Int, minute: Int)? { get }
    var block: Int { get }
    var priority: Int { get }
}

protocol GuideItemFactoryProtocol {

    func makePreparationItem(status: Guide.Item.Status,
                             representsMultiple: Bool,
                             startsTomorrow: Bool,
                             preparationLocalID: String?) -> Guide.Item?
    func makeItem(with item: GuideLearnItem) -> Guide.Item?
    func makeItem(with item: GuideNotificationItem) -> Guide.Item?
    func makeItem(with item: GuideNotificationConfiguration, date: ISODate) -> Guide.Item?
    func makeItem(with item: GuideDailyPrepResult) -> Guide.Item?
    func makeMessageText(with greeting: Guide.Message) -> String
    func userName() -> String?
}

struct GuideGenerator {

    let localCalendar: Calendar
    let maxDays: Int
    let factory: GuideItemFactoryProtocol
    let guideItemBlockDeterminer: GuideLearnItemBlockDeterminer

    init(localCalendar: Calendar = Calendar.current, maxDays: Int, factory: GuideItemFactoryProtocol) {
        self.localCalendar = localCalendar
        self.maxDays = maxDays
        self.factory = factory
        self.guideItemBlockDeterminer = GuideLearnItemBlockDeterminer(localCalendar: localCalendar)
    }

    func generateGuide(notificationItems: [GuideNotificationItem],
                       featureItems: [GuideLearnItem],
                       strategyItems: [GuideLearnItem],
                       notificationConfigurations: [GuideNotificationConfiguration],
                       dailyPrepResults: [GuideDailyPrepResult],
                       preparations: [GuidePreparation],
                       now: Date = Date()) throws -> Guide.Model {
        guard maxDays > 0 else { throw SimpleError(localizedDescription: "Incorrect maxDays: \(maxDays)") }

        let minDate = now.addingTimeInterval(-TimeInterval(days: maxDays - 1))
        let todaylocalStartOfDay = localCalendar.startOfDay(for: now)
        var days: [Date: Day] = [:]

        addNotificationItems(from: notificationItems, to: &days, now: now, minDate: minDate)
        addCompleteLearnItems(from: featureItems, to: &days, minDate: minDate, now: now)
        addIncompleteLearnItems(from: featureItems, to: &days, now: now, todayLocalStartOfDay: todaylocalStartOfDay)
        addCompleteLearnItems(from: strategyItems, to: &days, minDate: minDate, now: now)
        addIncompleteLearnItems(from: strategyItems, to: &days, now: now, todayLocalStartOfDay: todaylocalStartOfDay)
        addItems(configurations: notificationConfigurations,
                 dailyPrepResults: dailyPrepResults,
                 to: &days,
                 minDate: minDate,
                 now: now)
        addPreparations(from: preparations, to: &days, now: now, minDate: minDate)

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
        let isBeforNoon = localCalendar.component(.hour, from: now) < 12
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
                localDisplayDate >= localMinDate,
                let guideItem = factory.makeItem(with: item)
                else { continue }

            days.appendItem(guideItem,
                       hour: displayAt.hour,
                       minute: displayAt.minute,
                       priority: item.priority,
                       localStartOfDay: localCalendar.startOfDay(for: displayAt.utcDate))
        }
    }

    /**
     Adds imcomplete learn items to `days`.
     - Items are added to today's `Day` only.
     - Added items have the same block - the lowest incomplete block.
    */
    func addIncompleteLearnItems(from learnItems: [GuideLearnItem],
                                         to days: inout [Date: Day],
                                         now: Date,
                                         todayLocalStartOfDay: Date) {
        guard let block = guideItemBlockDeterminer.todaysBlockIndex(for: learnItems, now: now) else { return }

        let items = learnItems.filter {
            $0.block == block && $0.completedAt == nil && $0.displayAt != nil
        }
        for item in items {
            guard let guideItem = factory.makeItem(with: item), let displayAt = item.displayAt else { continue }

            days.appendItem(guideItem,
                            hour: displayAt.hour,
                            minute: displayAt.minute,
                            priority: item.priority,
                            localStartOfDay: todayLocalStartOfDay)
        }
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
                guard completedAt >= minDate,
                    completedAt <= now,
                    let guideItem = factory.makeItem(with: item),
                    let displayAt = item.displayAt else { continue }

                days.appendItem(guideItem,
                                hour: displayAt.hour,
                                minute: displayAt.minute,
                                priority: item.priority,
                                localStartOfDay: localCalendar.startOfDay(for: completedAt))
            }
        }

    }

    func addItems(configurations: [GuideNotificationConfiguration],
                  dailyPrepResults: [GuideDailyPrepResult],
                  to days: inout [Date: Day],
                  minDate: Date,
                  now: Date) {
        var date = now
        while date >= minDate {
            // FIXME: This currently only works when all GuideNotificationConfiguration are for daily preps.
            let localStartOfDay = localCalendar.startOfDay(for: date)
            var existsDailyPrepResult = false
            for dailyPrepResult in dailyPrepResults {
                let day = localCalendar.component(.day, from: date)
                let month = localCalendar.component(.month, from: date)
                let year = localCalendar.component(.year, from: date)

                if let displayAt = dailyPrepResult.displayAt,
                    day == displayAt.date.day,
                    month == displayAt.date.month,
                    year == displayAt.date.year {
                    if let item = factory.makeItem(with: dailyPrepResult) {
                        days.appendItem(item,
                                        hour: displayAt.hour,
                                        minute: displayAt.minute,
                                        priority: dailyPrepResult.priority,
                                        localStartOfDay: localStartOfDay)
                        existsDailyPrepResult = true
                    }
                }
            }

            if existsDailyPrepResult == false {
                for configuration in configurations {
                    let displayAt = configuration.displayAt
                    guard displayAt.weekday == localCalendar.component(.weekday, from: date) else { continue }

                    let displayAtDate = localCalendar.date(bySettingHour: displayAt.hour,
                                                           minute: displayAt.minute,
                                                           second: 0,
                                                           of: date)
                    let isoDate = localCalendar.isoDate(from: date)
                    if let displayAtDate = displayAtDate, now >= displayAtDate,
                        let guideItem = factory.makeItem(with: configuration, date: isoDate) {

                        days.appendItem(guideItem,
                                        hour: displayAt.hour,
                                        minute: displayAt.minute,
                                        priority: configuration.priority,
                                        localStartOfDay: localStartOfDay)
                    }
                }
            }
            guard let dayBefore = localCalendar.date(byAdding: .day, value: -1, to: date) else { break }
            date = dayBefore
        }
    }

    func addPreparations(from preparations: [GuidePreparation], to days: inout [Date: Day], now: Date, minDate: Date) {
        var date = now
        while date >= minDate {
            guard let nextDay = localCalendar.date(byAdding: .day, value: 1, to: date) else { break }

            var preparationsStartingTomorrow: [GuidePreparation] = []
            var preparationsStartingToday: [GuidePreparation] = []
            var preparationsStartedToday: [GuidePreparation] = []
            for preparation in preparations {
                guard let eventStart = preparation.eventStartDate else { continue }

                let nowIsAfter3PM = localCalendar.component(.hour, from: now) >= 15
                if localCalendar.isDate(eventStart, inSameDayAs: nextDay) && date == now && nowIsAfter3PM {
                    preparationsStartingTomorrow.append(preparation)
                } else if localCalendar.isDate(eventStart, inSameDayAs: date) {
                    if eventStart < now {
                        preparationsStartedToday.append(preparation)
                    } else {
                        preparationsStartingToday.append(preparation)
                    }
                }
            }

            var item: Guide.Item?
            if preparationsStartingToday.isEmpty == false {
                let multiple = preparationsStartingToday.count > 1
                let localID = preparationsStartingToday.count == 1 ? preparationsStartingToday[0].localID : nil
                item = factory.makePreparationItem(status: .todo,
                                                   representsMultiple: multiple,
                                                   startsTomorrow: false,
                                                   preparationLocalID: localID)
            } else if preparationsStartingTomorrow.isEmpty == false {
                let multiple = preparationsStartingTomorrow.count > 1
                let localID = preparationsStartingTomorrow.count == 1 ? preparationsStartingTomorrow[0].localID : nil
                item = factory.makePreparationItem(status: .todo,
                                                   representsMultiple: multiple,
                                                   startsTomorrow: true,
                                                   preparationLocalID: localID)
            } else if preparationsStartedToday.isEmpty == false {
                let multiple = preparationsStartedToday.count > 1
                let localID = preparationsStartedToday.count == 1 ? preparationsStartedToday[0].localID : nil
                item = factory.makePreparationItem(status: .done,
                                                   representsMultiple: multiple,
                                                   startsTomorrow: false,
                                                   preparationLocalID: localID)
            }
            let priority = 9999
            let startOfDay = localCalendar.startOfDay(for: date)
            if let item = item {
                days.appendItem(item, hour: 0, minute: 0, priority: priority, localStartOfDay: startOfDay)
            }

            guard let dayBefore = localCalendar.date(byAdding: .day, value: -1, to: date) else { break }
            date = dayBefore
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
        return filter { $0.status == .todo }.count == 0
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
