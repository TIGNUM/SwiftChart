//
//  WidgetDataManager.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 13/07/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

enum ExtensionDataType {
    case toBeVision
    case upcomingEvent
    case dailyPrep(items: [Guide.DailyPrepItem], feedback: String?, displayDate: Date)
    case all
}

final class ExtensionsDataManager {

    // MARK: - Properties

    private let services: Services

    // MARK: - Init

    init(services: Services) {
        self.services = services
    }

    // MARK: - Update cases

    func update(_ dataType: ExtensionDataType) {
        switch dataType {
        case .toBeVision:
            updateToBeVision()
        case .upcomingEvent:
            updateUpcomingEvents()
        case .dailyPrep(let items, let feedback, let displayDate):
            updateDailyPrep(items: items, feedback: feedback, displayDate: displayDate)
        case .all:
            updateAll()
        }
    }

    static func didUserLogIn(_ isLogedIn: Bool) {
        ExtensionUserDefaults.setIsUserSignedIn(value: isLogedIn)
    }
}

// MARK: - Private

private extension ExtensionsDataManager {

    func updateToBeVision() {
        let vision = services.userService.myToBeVision()
        let sharedVision = ExtensionModel.ToBeVision(headline: vision?.headline,
                                                     text: vision?.text,
                                                     imageURL: vision?.imageURL)
        ExtensionUserDefaults.set(sharedVision, for: .toBeVision)
    }

    func updateUpcomingEvents() {
        let events = Array(services.preparationService
            .preparations()
            .filter { $0.eventStartDate?.isPast == false })
            .sorted { $0.eventStartDate ?? Date() < $1.eventStartDate ?? Date() }
            .map { preparation in
                return ExtensionModel.UpcomingEvent(localID: preparation.localID,
                                                    eventName: preparation.name,
                                                    startDate: preparation.eventStartDate,
                                                    endDate: preparation.eventEndDate,
                                                    numberOfTasks: preparation.checkableItems.count,
                                                    tasksCompleted: preparation.coveredChecks.count) }
        ExtensionUserDefaults.set(events, for: .upcomingEvents)
    }

    func updateDailyPrep(items: [Guide.DailyPrepItem], feedback: String?, displayDate: Date) {
        let loadItems = items.filter {
            $0.title.lowercased().contains("length") ||
            $0.title.lowercased().contains("load") ||
            $0.title.lowercased().contains("pressure") }
        let loadValue = Float(loadItems.map { $0.result ?? 1 }.reduce(0, +)) / max(Float(loadItems.count), 1)
        let recoveryItems =  items.filter {
            $0.title.lowercased().contains("quality") ||
            $0.title.lowercased().contains("quantity") }
        let recoveryValue = Float(recoveryItems.map { $0.result ?? 1 }.reduce(0, +)) / max(Float(recoveryItems.count), 1)
        let dailyPrep = ExtensionModel.DailyPrep(loadValue: loadValue,
                                                 recoveryValue: recoveryValue,
                                                 feedback: feedback,
                                                 displayDate: displayDate)
        ExtensionUserDefaults.set(dailyPrep, for: .dailyPrep)
    }

    func updateAll() {
        updateToBeVision()
        updateUpcomingEvents()
    }
}

// MARK: - Siri Event Tracking

extension ExtensionsDataManager {

    func eventType(for siriEvent: SiriEventsModel.Event) -> AppEventRequest.EventType? {
        switch siriEvent.key {
        case ExtensionUserDefaults.toBeVision.rawValue:
            return .siriToBeVision
        case ExtensionUserDefaults.whatsHot.rawValue:
            return .siriWhatsHot
        case ExtensionUserDefaults.upcomingEvents.rawValue:
            return .siriUpcomingEvent
        case ExtensionUserDefaults.dailyPrep.rawValue:
            return .siriDailyPrep
        default:
            return nil
        }
    }
}
