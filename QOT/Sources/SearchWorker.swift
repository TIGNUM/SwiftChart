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
        return allResults.sorted { $0.title < $1.title }
    }()

    private lazy var contentItemsVideo: [Search.Result] = {
        let videoItems = Array(services.contentService.contentItemsVideo())
        var allResults = [Search.Result]()
        videoItems.forEach { (item) in
            var mediaURL: URL?
            if let urlString = item.valueMediaURL {
                mediaURL = URL(string: urlString)
            }
            let searchResult = Search.Result(filter: .video,
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
            let searchResult = Search.Result(filter: .audio,
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

    func search(_ searchText: String, searchFilter: Search.Filter) -> [Search.Result] {
        var searchArray = [Search.Result]()
        switch searchFilter {
        case .all: searchArray = contentCollectionsAll
        case .video: searchArray = contentItemsVideo
        case .audio: searchArray = contentItemsAudio
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
}
