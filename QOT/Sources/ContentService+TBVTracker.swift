//
//  ContentService+TBVTracker.swift
//  QOT
//
//  Created by Ashish Maheshwari on 10.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

extension ContentService {

    enum TBVTracker: String, CaseIterable, Predicatable {
        case title = "tbv_tracker_title"
        case subtitle = "tbv_tracker_subtitle"
        case graphTitle = "tbv_tracker_graphTitle"

        var predicate: NSPredicate {
            return NSPredicate(dalSearchTag: rawValue)
        }
    }
}
