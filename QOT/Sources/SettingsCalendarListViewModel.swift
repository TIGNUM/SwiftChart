//
//  SettingsCalendarListViewModel.swift
//  QOT
//
//  Created by karmic on 25.07.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

enum CalendarLocation: Int {
    case onThisDevice = 0
    case onOtherDevices
}

final class SettingsCalendarListViewModel {

    private let manager: CalendarSyncSettingsManager
    let syncStateObserver: SyncStateObserver
    var calendarsOnThisDevice: [CalendarSyncSetting] = []
    var calendarsOnOtherDevices: [CalendarSyncSetting] = []
    private var hasChanges: Bool = false

    var isSyncFinished: Bool {
        return syncStateObserver.hasSynced(RealmCalendarSyncSetting.self)
    }

    init(services: Services) {
        let manager = CalendarSyncSettingsManager(realmProvider: services.realmProvider)
        self.syncStateObserver = SyncStateObserver(realm: services.mainRealm)
        self.manager = manager
    }

    var calendarCountOnThisDevice: Int {
        return calendarsOnThisDevice.count
    }

    var calendarCountOnOtherDevices: Int {
        return calendarsOnOtherDevices.count
    }

    var cellHeight: CGFloat {
        return 60
    }

    func update() {
        let calendarSyncSettings = manager.calendarSyncSettings
        self.calendarsOnThisDevice = calendarSyncSettings.filter({ (setting) -> Bool in
            let exist = manager.calendarIdentifiersOnThisDevice.contains(obj: setting.identifier)
            return exist // existing on this device
        })
        self.calendarsOnOtherDevices = calendarSyncSettings.filter({ (setting) -> Bool in
            let exist = manager.calendarIdentifiersOnThisDevice.contains(obj: setting.identifier)
            return exist == false && setting.syncEnabled == true // Not existing on this device and if it's syncable.
        })
    }

    func calendarSyncSetting(_ type: CalendarLocation, index: Int) -> CalendarSyncSetting {
        switch type {
        case .onThisDevice :
            return calendarsOnThisDevice[index]
        default:
            return calendarsOnOtherDevices[index]
        }
    }

    func calendarSyncSetting(at indexPath: IndexPath) -> CalendarSyncSetting {
        let type = CalendarLocation(rawValue: indexPath.section) ?? .onOtherDevices
        return calendarSyncSetting(type, index: indexPath.row)
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

    func calendarSource(at indexPath: IndexPath) -> String? {
        return calendarSyncSetting(at: indexPath).source()
    }

    func headerTitle(in section: Int) -> String {
        let type = CalendarLocation(rawValue: section) ?? .onOtherDevices
        switch type {
        case .onThisDevice :
            return R.string.localized.settingsCalendarSectionOnThisDeviceHeader()
        default:
            return R.string.localized.settingsCalendarSectionOnOtherDevicesHeader()
        }
    }

    func updateCalendarSyncStatus(canSync: Bool, calendarIdentifier: String) {
        manager.setSyncEnabled(enabled: canSync, calendarIdentifier: calendarIdentifier)
        hasChanges = true
    }

    func isChanged() -> Bool {
        return hasChanges
    }
}
