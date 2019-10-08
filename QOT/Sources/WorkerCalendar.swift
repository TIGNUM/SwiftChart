//
//  WorkerCalendar.swift
//  QOT
//
//  Created by karmic on 08.10.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class WorkerCalendar {
    func getCalendarEvents(_ completion: @escaping ([QDMUserCalendarEvent]) -> Void) {
        CalendarService.main.getCalendarEvents(from: Date().beginingOfDate()) { (events, _, error) in
            if let error = error {
                log("Error getCalendarEvents: \(error.localizedDescription)", level: .error)
            }
            completion(events ?? [])
        }
    }

    func importCalendarEvents(_ newEvent: EKEvent?, _ completion: @escaping (QDMUserCalendarEvent?) -> Void) {
        CalendarService.main.importCalendarEvents { (events, _, error) in
            if let error = error {
                log("Error importCalendarEvents: \(error.localizedDescription)", level: .error)
            }
            let userEvent = events?.filter { $0.hasSameContent(from: newEvent) }.first
            completion(userEvent)
        }
    }

    func getCalendarSettings(_ completion: @escaping ([QDMUserCalendarSetting]) -> Void) {
        CalendarService.main.getCalendarSettings { (calendarSettings, _, error) in
            if let error = error {
                log("Error getCalendarSettings: \(error.localizedDescription)", level: .error)
            }
            completion(calendarSettings ?? [])
        }
    }

    func updateCalendarSetting(_ calendarSetting: QDMUserCalendarSetting?,
                               _ completion: ((QDMUserCalendarSetting?) -> Void)?) {
        guard let setting = calendarSetting else { return }
        CalendarService.main.updateCalendarSetting(setting) { (calendarSetting, error) in
            if let error = error {
                log("Error updateCalendarSetting: \(error.localizedDescription)", level: .error)
            }
            completion?(calendarSetting)
        }
    }

    func updateCalendarSettings(_ settings: [QDMUserCalendarSetting]) {
        CalendarService.main.updateCalendarSettings(settings) { (error) in
            if let error = error {
                log("Error updateCalendarSetting: \(error.localizedDescription)", level: .error)
            }
        }
    }

    func hasSyncedCalendars(_ completion: @escaping (Bool) -> Void) {
        getCalendarSettings { (settings) in
            let hasSyncedCalenders = settings.filter { (setting) -> Bool in
                let isLocal = EKEventStore.shared.localIds.contains(obj: setting.calendarId ?? "")
                return isLocal && setting.syncEnabled == true
            }.isEmpty == false
            completion(hasSyncedCalenders)
        }
    }
}
