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

    func getViewTitle(_ completion: @escaping (String) -> Void) {
        let predicate = NSPredicate(dalSearchTag: "synced_calendars_synced_calendars")
        qot_dal.ContentService.main.getContentItemByPredicate(predicate) { (contentItem) in
            completion(contentItem?.valueText ?? "")
        }
    }

    func getCalendarSettings(_ completion: @escaping ([QDMUserCalendarSetting]) -> Void) {
        qot_dal.CalendarService.main.getCalendarSettings { (calendarSettings, _, error) in
            if let error = error {
                qot_dal.log("Error getCalendarSettings: \(error.localizedDescription)", level: .error)
            }
            completion(calendarSettings ?? [])
        }
    }
}

// MARK: - Public
extension SyncedCalendarsWorker {

}
