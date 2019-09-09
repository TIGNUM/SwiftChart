//
//  SearchModels.swift
//  QOT
//
//  Created by karmic on 08.03.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation
import qot_dal

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

        func mediaIcon() -> UIImage? {
            switch self {
            case .video:
                return R.image.my_library_camera()
            case .audio:
                return R.image.my_library_listen()
            case .pdf, .article:
                return R.image.my_library_read()
            case .tool:
                return R.image.ic_group_sand()
            }
        }

    }

    struct Result: Equatable {
        let filter: Filter
        let title: String
        let contentID: Int?
        let contentItemID: Int?
        let createdAt: Date
        let searchTags: String
        let section: ContentSection?
        let mediaURL: URL?
        let displayType: DisplayType
        let duration: String

        static func == (lhs: Search.Result, rhs: Search.Result) -> Bool {
            return lhs.title == rhs.title && lhs.displayType == rhs.displayType
        }
    }

    static func resultFrom(_ contentCollections: [QDMContentCollection],
                           filter: Filter,
                           displayType: DisplayType) -> [Search.Result] {
        return contentCollections.compactMap({
            Search.Result(filter: filter,
                          title: $0.title,
                          contentID: $0.remoteID ?? 0,
                          contentItemID: nil,
                          createdAt: $0.createdAt ?? Date(),
                          searchTags: "",
                          section: ContentSection(rawValue: $0.section.rawValue),
                          mediaURL: nil,
                          displayType: displayType,
                          duration: $0.durationString)
        })
    }

    static func resultFrom(_ contentItem: QDMContentItem, filter: Filter, displayType: DisplayType) -> Search.Result {
        return Search.Result(filter: filter,
                             title: contentItem.valueText,
                             contentID: nil,
                             contentItemID: contentItem.remoteID ?? 0,
                             createdAt: contentItem.createdAt ?? Date(),
                             searchTags: "",
                             section: nil,
                             mediaURL: URL(string: contentItem.valueMediaURL ?? ""),
                             displayType: displayType,
                             duration: contentItem.durationString)
    }
}

struct SearchSuggestions {
    let header: String
    let suggestions: [String]
}
