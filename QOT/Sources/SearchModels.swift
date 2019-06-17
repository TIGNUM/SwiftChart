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
        case read
        case listen
        case watch
        case tools

        var title: String {
            switch self {
            case .all: return R.string.localized.searchFilterAll()
            case .read: return R.string.localized.searchFilterRead()
            case .listen: return R.string.localized.searchFilterListen()
            case .watch: return R.string.localized.searchFilterWatch()
            case .tools: return R.string.localized.searchFilterTools()
            }
        }
        var userEvent: String {
            switch self {
            case .all: return "SEARCH_ALL"
            case .read: return "SEARCH_READ"
            case .listen: return "SEARCH_LISTEN"
            case .watch: return "SEARCH_WATCH"
            case .tools: return "SEARCH_TOOLS"
            }
        }
    }

    enum DisplayType: String {
        case article
        case audio
        case video
        case pdf
        case tool
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
            return lhs.title == rhs.title && lhs.displayType == rhs.displayType
        }
    }
}

struct SearchSuggestions {
    let header: String
    let suggestions: [String]
}
