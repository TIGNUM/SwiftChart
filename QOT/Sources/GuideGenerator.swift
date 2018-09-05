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

protocol GuideWhatsHotItem {

	var remoteID: String { get }
	var createdAt: Date { get }
	var viewed: Bool { get }
	var title: String { get }
	var imageURL: URL { get }
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

	func generateGuide(toBeVisionItem: Guide.Item,
					   whatsHotItems: [(Date, Guide.Item)],
					   notificationItems: [GuideNotificationItem],
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
		addWhatsHotItems(from: whatsHotItems, to: &days, now: now, minDate: minDate)
		addToBeVisionItem(from: toBeVisionItem, to: &days)
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
		let message = guideMessage(today: guideDays[todaylocalStartOfDay],
								   featureItems: featureItems,
								   strategyItems: strategyItems,
								   notificationitems: notificationItems)
		return Guide.Model(days: sortedDays,
						   greeting: greeting(userName: factory.userName(), now: now),
						   message: factory.makeMessageText(with: message))
	}

    /**
     TODAY -> `ITEM` not finished

     1.-> `DAILY PREP` -> "Let's start with a quick check in, so I can help support you today."
     2.-> `LEARNING PLAN` -> "Let me help you dive deeper into today's strategy."
     3.-> `WHATSHOT` -> Random between:
        1. If you feel your pocket getting hot, it's probably because I just loaded a new What’s Hot article for you.
        2. Check out today's What's Hot article.
        3. Scroll down to check out What's Hot today.
        4. Sustainable High Performance is all around us. Check out What's Hot to see where it showed up today.
     4-> `TOBEVISION` -> Random between:
        1. Today's a great day to create your why. Scroll down for help creating your To Be Vision.
        2. Your self-image is what drives you to Rule Your Impact. Let me help you create yours today.
        3. Feel the impact you can make by letting me help you create your To Be Vision.

     TODAY -> All items finished

     1.-> Random between:
        1. How much impact would I have today if I were my To Be Vision?
        2. Bring your best today by being your To Be Vision.
     */

    private func guideMessage(today: Guide.Day?,
                              featureItems: [GuideLearnItem],
                              strategyItems: [GuideLearnItem],
                              notificationitems: [GuideNotificationItem]) -> Guide.Message {
		var learnItems: [GuideLearnItem] = featureItems
        learnItems.append(contentsOf: strategyItems)
        if let today = today {
            if today.hasIncompleteDailyPrep == true {
                return .prepNotFinished
            } else if today.hasIncompleteLearnItem == true {
                return .learningPlanNotFinished
            } else if today.hasIncompleteWhatsHotItem == true {
                let messages: [Guide.Message] = [.whatsHotNotFinished1,
                                                 .whatsHotNotFinished2,
                                                 .whatsHotNotFinished3,
                                                 .whatsHotNotFinished4]
                return messages.item(at: messages.randomIndex)
            } else if today.hasIncompleteToBeVision == true {
                let messages: [Guide.Message] = [.toBeVisionNotFinished1, .toBeVisionNotFinished2]
                return messages.item(at: messages.randomIndex)
            }
        }

        let messages: [Guide.Message] = [.todayFinished1, .todayFinished2]
        return messages.item(at: messages.randomIndex)
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
	Adds ToBeVision item to today.
	*/
	func addToBeVisionItem(from item: Guide.Item, to days: inout [Date: Day]) {
		days.appendItem(item, hour: 24, minute: 00, priority: 0, localStartOfDay: localCalendar.startOfDay(for: Date()))
	}

	/**
	Adds latest WhatsHot item item to the day it's been created.
	*/
	func addWhatsHotItems(from items: [(Date, Guide.Item)], to days: inout [Date: Day], now: Date, minDate: Date) {
		let localMinDate = localCalendar.startOfDay(for: minDate)
		for item in items {
			let displayDate = item.0
			if displayDate <= now && displayDate >= localMinDate {
				days.appendItem(item.1,
								hour: 23,
								minute: 59,
								priority: 0,
								localStartOfDay: localCalendar.startOfDay(for: item.0))
			}
		}
	}

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

    var hasIncompleteLearnItem: Bool {
        return items.filter { $0.isLearningPlan == true && $0.status == .todo }.count > 0
    }

    var hasIncompleteWhatsHotItem: Bool {
        return items.filter { $0.isWhatsHot == true && $0.status == .todo }.count > 0
    }

    var hasIncompleteToBeVision: Bool {
        return items.filter { $0.isToBeVision == true && $0.status == .todo }.count > 0
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
