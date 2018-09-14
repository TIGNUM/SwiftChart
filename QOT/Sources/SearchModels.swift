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
        case audio
        case video

        var title: String {
            switch self {
            case .all: return R.string.localized.searchFilterAll()
            case .video: return R.string.localized.searchFilterVideo()
            case .audio: return R.string.localized.searchFilterAudio()
            }
        }
    }

    enum DisplayType: String {
        case article
        case audio
        case video
    }

    struct Result: Equatable {
        let filter: Filter
        let title: String
        let contentID: Int?
        let contentItemID: Int?
        let createdAt: Date
        let searchTags: String
        let section: Database.Section?
        let mediaURL: URL?
        let displayType: DisplayType
        let duration: String

        static func == (lhs: Search.Result, rhs: Search.Result) -> Bool {
            return
                lhs.title == rhs.title &&
                lhs.displayType == rhs.displayType
        }
    }
}
