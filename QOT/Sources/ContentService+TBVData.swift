//
//  ContentService+TBVData.swift
//  QOT
//
//  Created by Ashish Maheshwari on 10.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

extension ContentService {

    enum TBVData: String, CaseIterable, Predicatable {
        case title = "tbv_data_title"
        case subtitle = "tbv_data_subtitle"
        case graphTitle = "tbv_data_graphTitle"
        case emptyStateHeaderTitle = "tbv_data_empty_state_headerTitle"
        case emptyStateHeaderDesc = "tbv_data_empty_state_headerDescrption"
        case emptyStateTitleTitle = "tbv_data_empty_state_titleTitle"
        case emptyStateTitleDesc = "tbv_data_empty_state_titleDescription"

        var predicate: NSPredicate {
            return NSPredicate(dalSearchTag: rawValue)
        }
    }
}
