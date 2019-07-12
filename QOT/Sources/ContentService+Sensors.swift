//
//  ContentService+Sensors.swift
//  QOT
//
//  Created by Ashish Maheshwari on 15.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

extension ContentService {

    enum Sensors: String, CaseIterable, Predicatable {
        case activityTrackers = "activity_trackers_activity_trackers"
        case sensors = "activity_trackers_sensors"
        case requestActivityTracker = "activity_trackers_request_tracker"
        var predicate: NSPredicate {
            return NSPredicate(dalSearchTag: rawValue)
        }
    }
}
