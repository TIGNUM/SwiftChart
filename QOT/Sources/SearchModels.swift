//
//  SearchModels.swift
//  QOT
//
//  Created by karmic on 08.03.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

struct Search {

    enum Filter: Int {
        case all = 0
        case video
        case audio
    }

    enum DisplayType: String {
        case article
        case audio
        case video
    }

    struct Result {
        let type: Filter
        let title: String
        let contentID: Int
        let createdAt: Date
        let searchTags: String
        let section: Database.Section?
        let mediaURL: URL?
        let displayType: DisplayType
        let duration: String
    }
}
