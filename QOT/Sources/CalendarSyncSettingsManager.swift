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
    func source() -> String? {
        let elements = identifier.components(separatedBy: Toggle.seperator)
        return elements.last
    }
}

final class CalendarSyncSettingsManager {

    private let eventStore: EKEventStore
    private let realmProvider: RealmProvider
    private let syncManager: SyncManager

    init(eventStore: EKEventStore = EKEventStore.shared, realmProvider: RealmProvider) {
        self.eventStore = eventStore
        self.realmProvider = realmProvider
        self.syncManager = AppDelegate.current.appCoordinator.syncManager
    }

    var calendarIdentifiersOnThisDevice: [String] {
        return eventStore.calendars(for: .event).compactMap { String($0.toggleIdentifier) }
    }

    var syncEnabledCalendars: [EKCalendar] {
        do {
            return try eventStore.calendars(for: .event).filter {
                try syncEnabled(toggleIdentifier: $0.toggleIdentifier, title: $0.title)
            }
        } catch {
            assertionFailure("Failed to fetch syncEnabledCalendars: \(error)")
            return []
        }
    }

    var calendarSyncSettings: [CalendarSyncSetting] {
        do {
            var settings: [String: CalendarSyncSetting] = [:]
            let realm = try realmProvider.realm()
            let existingCalendarSettings = realm.objects(RealmCalendarSyncSetting.self)

            for calendar in existingCalendarSettings {
                let id = calendar.localID
                let title = calendar.title
                let enabled = try syncEnabled(toggleIdentifier: id, title: title)
                let setting = CalendarSyncSetting(identifier: id, title: title, syncEnabled: enabled)
                settings[id] = setting
            }
            return settings.values.map { $0 }
        } catch {
            assertionFailure("Failed to fetch calendarSyncSettings: \(error)")
            return []
        }
    }

    func setSyncEnabled(enabled: Bool, calendarIdentifier: String) {
        var calendarToSync: EKCalendar?

        for calendar in eventStore.calendars(for: .event) where calendar.toggleIdentifier == calendarIdentifier {
            calendarToSync = calendar
        }

        guard let calendar = calendarToSync else { return }
        do {
            let realm = try realmProvider.realm()
            let setting = try calendarSyncSetting(toggleIdentifier: calendar.toggleIdentifier, title: calendar.title)
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
                // The this function will create and update objects as needed
                _ = try calendarSyncSetting(toggleIdentifier: calendar.toggleIdentifier, title: calendar.title)
            }
        }
    }

    func syncEnabled(toggleIdentifier: String, title: String) throws -> Bool {
        return try calendarSyncSetting(toggleIdentifier: toggleIdentifier, title: title).syncEnabled
    }
}

private extension CalendarSyncSettingsManager {

    func calendarSyncSetting(toggleIdentifier: String, title: String) throws -> RealmCalendarSyncSetting {
        let realm = try realmProvider.realm()
        let id = toggleIdentifier
        let result: RealmCalendarSyncSetting
        if let existing = realm.object(ofType: RealmCalendarSyncSetting.self, forPrimaryKey: id) {
            if existing.title != title {
                try realm.transactionSafeWrite {
                    existing.title = title
                    existing.didUpdate()
                }
            }
            result = existing
        } else {
            let isDefaultCalendar = id == eventStore.defaultCalendarForNewEvents?.toggleIdentifier
            let new = RealmCalendarSyncSetting(calendarIdentifier: toggleIdentifier,
                                               title: title,
                                               syncEnabled: isDefaultCalendar)
            try realm.transactionSafeWrite {
                realm.addObject(new)
            }
            result = new
            syncManager.syncCalendarSyncSettings()
//            syncManager.syncCalendarEvents()
        }
        return result
    }
}
