//
//  ExtensionsDataManager.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 13/07/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation
import qot_dal

enum ExtensionDataType {
    case toBeVision
    case upcomingEvent
    case dailyPrep(items: [Guide.DailyPrepItem], feedback: String?, displayDate: Date)
    case all
}

final class ExtensionsDataManager {

    // MARK: - Init

    init() {
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
        if UserDefault.myDataSelectedItems.object as? [Int] == nil {
            let rawValues = MyDataSelectionModel.sectionValues.map { (parameter) -> Int in
                return parameter.rawValue
            }
            UserDefault.myDataSelectedItems.setObject(rawValues)
        }
    }
}

// MARK: - Private

private extension ExtensionsDataManager {

    func updateToBeVision() {
        qot_dal.UserService.main.getMyToBeVision {(vision, status, error) in
            let sharedVision = ExtensionModel.ToBeVision(headline: vision?.headline,
                                                         text: vision?.text,
                                                         imageURL: vision?.profileImageResource?.url())
            ExtensionUserDefaults.set(sharedVision, for: .toBeVision)
        }
    }

    func updateUpcomingEvents() {
        qot_dal.UserService.main.getUserPreparations { (preparations, initiated, error) in
            guard let preparations = preparations, error == nil else {
                return
            }

            let events = preparations.filter { $0.eventDate != nil && $0.eventDate?.isPast() == false }
                .sorted { $0.eventDate ?? Date() < $1.eventDate ?? Date() }
                .map { preparation in
                    return ExtensionModel.UpcomingEvent(localID: preparation.qotId!,
                                                        eventName: preparation.eventTitle!,
                                                        startDate: preparation.eventDate ?? Date(),
                                                        endDate: Date(),
                                                        numberOfTasks: 0,
                                                        tasksCompleted: 0) }
            ExtensionUserDefaults.set(events, for: .upcomingEvents)

        }
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
