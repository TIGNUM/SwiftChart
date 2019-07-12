//
//  ContentService+SyncedCalendars.swift
//  QOT
//
//  Created by Ashish Maheshwari on 15.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

extension ContentService {

    enum SyncedCalendars: String, CaseIterable, Predicatable {
        case syncedCalendars = "synced_calendars_synced_calendars"

        var predicate: NSPredicate {
            return NSPredicate(dalSearchTag: rawValue)
        }
    }
}
