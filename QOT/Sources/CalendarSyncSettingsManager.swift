//
//  CalendarSyncSettingsManager.swift
//  QOT
//
//  Created by Sam Wyndham on 16/01/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

struct CalendarSyncSetting {

    let identifier: String
    let title: String
    let syncEnabled: Bool
}

final class CalendarSyncSettingsManager {

    private let eventStore: EKEventStore
    private let realmProvider: RealmProvider

    init(eventStore: EKEventStore = EKEventStore.shared, realmProvider: RealmProvider) {
        self.eventStore = eventStore
        self.realmProvider = realmProvider
    }

    var syncEnabledCalendars: [EKCalendar] {
        do {
            return try eventStore.calendars(for: .event).filter(syncEnabled)
        } catch {
            assertionFailure("Failed to fetch syncEnabledCalendars: \(error)")
            return []
        }
    }

    var calendarSyncSettings: [CalendarSyncSetting] {
        do {
            return try eventStore.calendars(for: .event).map { (calendar) in
                return CalendarSyncSetting(identifier: calendar.calendarIdentifier,
                                           title: calendar.title,
                                           syncEnabled: try syncEnabled(for: calendar))
            }
        } catch {
            assertionFailure("Failed to fetch calendarSyncSettings: \(error)")
            return []
        }
    }

    func setSyncEnabled(enabled: Bool, calendarIdentifier: String) {
        guard let calendar = eventStore.calendar(withIdentifier: calendarIdentifier) else { return }
        do {
            let realm = try realmProvider.realm()
            let setting = try calendarSyncSetting(for: calendar)
            if setting.syncEnabled != enabled {
                try realm.transactionSafeWrite {
                    setting.syncEnabled = enabled
                    setting.didUpdate()
                }
            }
        } catch {
            assertionFailure("Failed ot set calendar sync enabled: \(error)")
        }
    }

    func updateSyncSettingsWithEventStore() throws {
        let realm = try realmProvider.realm()
        try realm.transactionSafeWrite {
            for calendar in eventStore.calendars(for: .event) {
                _ = try calendarSyncSetting(for: calendar) // The this function will create and update objects as needed
            }
        }
    }
}

private extension CalendarSyncSettingsManager {

    func syncEnabled(for calendar: EKCalendar) throws -> Bool {
        return try calendarSyncSetting(for: calendar).syncEnabled
    }

    func calendarSyncSetting(for calendar: EKCalendar) throws -> RealmCalendarSyncSetting {
        let realm = try realmProvider.realm()
        let id = calendar.calendarIdentifier
        if let existing = realm.object(ofType: RealmCalendarSyncSetting.self, forPrimaryKey: id) {
            if existing.title != calendar.title {
                try realm.transactionSafeWrite {
                    existing.title = calendar.title
                    existing.didUpdate()
                }
            }
            return existing
        } else {
            let isDefaultCalendar = id == eventStore.defaultCalendarForNewEvents?.calendarIdentifier
            let new = RealmCalendarSyncSetting(calendarIdentifier: calendar.calendarIdentifier,
                                               title: calendar.title,
                                               syncEnabled: isDefaultCalendar)
            try realm.transactionSafeWrite {
                realm.addObject(new)
            }
            return new
        }
    }
}
