//
//  SettingsCalendarListViewModel.swift
//  QOT
//
//  Created by karmic on 25.07.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import EventKit

final class SettingsCalendarListViewModel {

    fileprivate let services: Services

    init(services: Services) {
        self.services = services
    }

    var calendarCount: Int {
        return EKEventStore.shared.calendarSyncSettings.count
    }

    func calendarSyncSetting(at indexPath: IndexPath) -> CalendarSyncSetting {
        return EKEventStore.shared.calendarSyncSettings[indexPath.row]
    }

    func calendarName(at indexPath: IndexPath) -> String {
        return calendarSyncSetting(at: indexPath).title
    }

    func calendarSyncStatus(at indexPath: IndexPath) -> Bool {
        return calendarSyncSetting(at: indexPath).syncEnabled
    }

    func calendarIdentifier(at indexPath: IndexPath) -> String? {
        return calendarSyncSetting(at: indexPath).identifier
    }

    func updateCalendarSyncStatus(canSync: Bool, calendarIdentifier: String) {
        EKEventStore.shared.setSyncEnabled(enabled: canSync, calendarIdentifier: calendarIdentifier)
    }
}
