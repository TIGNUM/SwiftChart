//
//  ContentService+MyVision.swift
//  QOT
//
//  Created by Ashish Maheshwari on 11.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

extension ContentService {

    enum MyVision: String, CaseIterable, Predicatable {
        case syncingtext = "myVision_rate_syncingText"
        case notRatedText = "myVision_rate_notRatedText"
        case nullStateTitle = "myVision_nullStateTitle"
        case nullStateSubtitle = "myVision_nullStateSubtitle"
        case visionTitle = "myVision_visionTitle"
        case visionDescription = "myVision_visionDescription"

        var predicate: NSPredicate {
            return NSPredicate(dalSearchTag: rawValue)
        }
    }
}
