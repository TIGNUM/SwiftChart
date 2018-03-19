//
//  SettingsCalendarListViewModel.swift
//  QOT
//
//  Created by karmic on 25.07.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

final class SettingsCalendarListViewModel {

    private let manager: CalendarSyncSettingsManager
    let syncStateObserver: SyncStateObserver

    var isSyncFinished: Bool {
        return syncStateObserver.hasSynced(RealmCalendarSyncSetting.self)
    }

    init(services: Services) {
        self.manager = CalendarSyncSettingsManager(realmProvider: services.realmProvider)
        self.syncStateObserver = SyncStateObserver(realm: services.mainRealm)
    }

    var calendarCount: Int {
        return manager.calendarSyncSettings.count
    }

    func calendarSyncSetting(at indexPath: IndexPath) -> CalendarSyncSetting {
        return manager.calendarSyncSettings[indexPath.row]
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
        manager.setSyncEnabled(enabled: canSync, calendarIdentifier: calendarIdentifier)
    }
}
