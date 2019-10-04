//
//  SyncedCalendarsWorker.swift
//  QOT
//
//  Created by Ashish Maheshwari on 15.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class SyncedCalendarsWorker {
    lazy var viewTitle: String = {
        return ScreenTitleService.main.localizedString(for: .syncedCalendars)
    }()

    lazy var skipButton: String = {
        return R.string.localized.syncedCalendarsButtonSkip()
    }()

    lazy var saveButton: String = {
        return R.string.localized.syncedCalendarsButtonSave()
    }()
}

// MARK: - Public
extension SyncedCalendarsWorker {

    func getCalendarSettings(_ completion: @escaping ([QDMUserCalendarSetting]) -> Void) {
        CalendarService.main.getCalendarSettings { (calendarSettings, _, error) in
            if let error = error {
                qot_dal.log("Error getCalendarSettings: \(error.localizedDescription)", level: .error)
            }
            completion(calendarSettings ?? [])
        }
    }

    func updateCalendarSetting(_ calendarSetting: QDMUserCalendarSetting?,
                               _ completion: ((QDMUserCalendarSetting?) -> Void)?) {
        guard let setting = calendarSetting else { return }
        CalendarService.main.updateCalendarSetting(setting) { (calendarSetting, error) in
            if let error = error {
                qot_dal.log("Error updateCalendarSetting: \(error.localizedDescription)", level: .error)
            }
            completion?(calendarSetting)
        }
    }

    func getCalendarEvents(_ completion: @escaping ([QDMUserCalendarEvent]) -> Void) {
        CalendarService.main.getCalendarEvents { (events, initialized, error) in
            if let error = error {
                qot_dal.log("Error fetching calendar events: \(error.localizedDescription)", level: .error)
            }
            completion(events ?? [])
        }
    }
}
