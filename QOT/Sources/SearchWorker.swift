//
//  SearchWorker.swift
//  QOT
//
//  Created by karmic on 08.03.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

final class SearchWorker {

    private let services: Services
    private let networkManager: NetworkManager

    init(services: Services, networkManager: NetworkManager) {
        self.services = services
        self.networkManager = networkManager
    }

    private lazy var contentCollectionsAll: [Search.Result] = {
        let contentCollections = Array(services.contentService.searchContentCollections())
        var allResults = [Search.Result]()
        contentCollections.forEach { (content) in
            let searchResult = Search.Result(filter: .all,
                                             title: content.title,
                                             contentID: content.remoteID.value ?? 0,
                                             contentItemID: nil,
                                             createdAt: content.createdAt,
                                             searchTags: content.searchTags,
                                             section: Database.Section(rawValue: content.section),
                                             mediaURL: nil,
                                             displayType: .article,
                                             duration: content.durationString)
            allResults.append(searchResult)
        }
        allResults.append(contentsOf: contentItemsAudio)
        allResults.append(contentsOf: contentItemsVideo)
        allResults.append(contentsOf: contentItemsPDF)
        allResults.append(contentsOf: contentItemsTools)
        return allResults.sorted { $0.title < $1.title }
    }()

    private lazy var contentItemsPDF: [Search.Result] = {
        let pdfItems = Array(services.contentService.contentItemsPDF())
        var allResults = [Search.Result]()
        pdfItems.forEach { (item) in
            var mediaURL: URL?
            if let urlString = item.valueMediaURL {
                mediaURL = URL(string: urlString)
            }
            let searchResult = Search.Result(filter: .all,
                                             title: item.valueText ?? "",
                                             contentID: nil,
                                             contentItemID: item.remoteID.value,
                                             createdAt: item.createdAt,
                                             searchTags: item.searchTags,
                                             section: nil,
                                             mediaURL: mediaURL,
                                             displayType: .pdf,
                                             duration: item.durationString)
            allResults.append(searchResult)
        }
        return allResults
    }()

    private lazy var contentItemsVideo: [Search.Result] = {
        let videoItems = Array(services.contentService.contentItemsVideo())
        var allResults = [Search.Result]()
        videoItems.forEach { (item) in
            var mediaURL: URL?
            if let urlString = item.valueMediaURL {
                mediaURL = URL(string: urlString)
            }
            let searchResult = Search.Result(filter: .watch,
                                             title: item.valueText ?? "",
                                             contentID: nil,
                                             contentItemID: item.remoteID.value,
                                             createdAt: item.createdAt,
                                             searchTags: item.searchTags,
                                             section: nil,
                                             mediaURL: mediaURL,
                                             displayType: .video,
                                             duration: item.durationString)
            allResults.append(searchResult)
        }
        return allResults
    }()

    private lazy var contentItemsAudio: [Search.Result] = {
        let audioItems = Array(services.contentService.contentItemsAudio())
        var allResults = [Search.Result]()
        audioItems.forEach { (item: ContentItem) in
            var mediaURL: URL?
            if let urlString = item.valueMediaURL {
                mediaURL = item.bundledAudioURL ?? URL(string: urlString)
            }
            let searchResult = Search.Result(filter: .listen,
                                             title: item.valueText ?? "",
                                             contentID: nil,
                                             contentItemID: item.remoteID.value,
                                             createdAt: item.createdAt,
                                             searchTags: item.searchTags,
                                             section: nil,
                                             mediaURL: mediaURL,
                                             displayType: .audio,
                                             duration: item.durationString)
            allResults.append(searchResult)
        }
        return allResults
    }()

    private lazy var contentItemsTools: [Search.Result] = {
        let categories = Array(services.contentService.toolsCategories())
        let toolsCollections = categories.map { return Array($0.contentCollections(section: .library)) }
        var allResults: [Search.Result] = []
        for collections in toolsCollections {
            for collection in collections {
                let result = Search.Result(filter: .tools,
                                           title: collection.title,
                                           contentID: collection.remoteID.value,
                                           contentItemID: collection.remoteID.value,
                                           createdAt: collection.createdAt,
                                           searchTags: collection.searchTags,
                                           section: Database.Section(rawValue: collection.section),
                                           mediaURL: nil,
                                           displayType: .tool,
                                           duration: collection.durationString)
                allResults.append(result)
            }
        }
        return allResults
    }()

    private lazy var contentItemsRead: [Search.Result] = {
        let readContentCollections: [ContentCollection] = Array(services.contentService.searchReadContentCollections())
        var allResults: [Search.Result] = []
        for collection in readContentCollections {
            let result = Search.Result(filter: .read,
                                       title: collection.title,
                                       contentID: collection.remoteID.value ?? 0,
                                       contentItemID: nil,
                                       createdAt: collection.createdAt,
                                       searchTags: collection.searchTags,
                                       section: Database.Section(rawValue: collection.section),
                                       mediaURL: nil,
                                       displayType: .article,
                                       duration: collection.durationString)
            allResults.append(result)
        }
        allResults.append(contentsOf: contentItemsPDF)
        return allResults
    }()

    func search(_ searchText: String, searchFilter: Search.Filter) -> [Search.Result] {
        var searchArray = [Search.Result]()
        switch searchFilter {
        case .all: searchArray = contentCollectionsAll
        case .read: searchArray = contentItemsRead
        case .listen: searchArray = contentItemsAudio
        case .watch: searchArray = contentItemsVideo
        case .tools: searchArray = contentItemsTools
        }
        let searchResults = searchArray.filter { (item) -> Bool in
            return item.title.lowercased().contains(searchText.lowercased())
                || item.searchTags.lowercased().contains(searchText.lowercased())
        }
        return removeDuplicates(from: searchResults)
    }

    private func removeDuplicates(from results: [Search.Result]) -> [Search.Result] {
        var tempResults = [Search.Result]()
        for result in results {
            if tempResults.contains(obj: result) == false {
                tempResults.append(result)
            }
        }
        return tempResults
    }

    func sendUserSearchResult(contentId: Int?, contentItemId: Int?, filter: Search.Filter, query: String) {
        networkManager.performUserSearchResultRequest(contentId: contentId,
                                                      contentItemId: contentItemId,
                                                      filter: filter,
                                                      query: query) { (error) in
                                                        if error != nil {
                                                            log("UserSearchResult ERROR: \(String(describing: error))",
                                                                level: .error)
                                                        }
        }
    }

    func suggestions() -> SearchSuggestions {
        return SearchSuggestions(header: services.contentService.searchSuggestionsHeader(),
                                 suggestions: services.contentService.searchSuggestions())
    }

    func contentItem(for searchResult: Search.Result) -> ContentItem? {
        guard let contentItemID = searchResult.contentItemID else { return nil }
        return services.contentService.contentItem(id: contentItemID)
    }
}
