//
//  SearchWorker.swift
//  QOT
//
//  Created by karmic on 08.03.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class SearchWorker {

    init() {
    }

    func search(_ searchText: String, searchFilter: Search.Filter, _ completion: @escaping ([Search.Result]) -> Void) {
        switch searchFilter {
        case .all:
            qot_dal.ContentService.main.getAllFor(keyword: searchText) { (contentCollections, contentItems) in
                var searchArray = [Search.Result]()
                if let collections = contentCollections {
                    searchArray.append(contentsOf: Search.resultFrom(collections, filter: searchFilter, displayType: .article))
                }
                if let items = contentItems {
                    searchArray.append(contentsOf: self.contentItemResultsFrom(contentItems: items, filter: searchFilter))
                }
                completion(self.removeDuplicates(from: searchArray))
            }
        case .read:
            qot_dal.ContentService.main.getAllReadablesFor(keyword: searchText) { (contentCollections, contentItems) in
                var searchArray = [Search.Result]()
                if let collections = contentCollections {
                    searchArray.append(contentsOf: Search.resultFrom(collections, filter: searchFilter, displayType: .article))
                }
                if let items = contentItems {
                    searchArray.append(contentsOf: self.contentItemResultsFrom(contentItems: items, filter: searchFilter))
                }
                completion(self.removeDuplicates(from: searchArray))
            }
        case .listen:
            qot_dal.ContentService.main.getAudioItemsFor(keyword: searchText) { (contentItems) in
                var searchArray = [Search.Result]()
                if let items = contentItems {
                    searchArray.append(contentsOf: self.contentItemResultsFrom(contentItems: items, filter: searchFilter))
                }
                completion(self.removeDuplicates(from: searchArray))
            }
        case .watch:
            qot_dal.ContentService.main.getVideoItemsFor(keyword: searchText) { (contentItems) in
                var searchArray = [Search.Result]()
                if let items = contentItems {
                    searchArray.append(contentsOf: self.contentItemResultsFrom(contentItems: items, filter: searchFilter))
                }
                searchArray.sort(by: { $0.title < $1.title })
                completion(self.removeDuplicates(from: searchArray))
            }
        case .tools:
            qot_dal.ContentService.main.getToolsContentCollectionsFor(keyword: searchText) { (contentCollections) in
                var searchArray = [Search.Result]()
                if let collections = contentCollections {
                    searchArray.append(contentsOf: Search.resultFrom(collections, filter: searchFilter, displayType: .tool))
                }
                searchArray.sort(by: { $0.title < $1.title })
                completion(self.removeDuplicates(from: searchArray))
            }
        }
    }

    private func contentItemResultsFrom(contentItems: [QDMContentItem], filter: Search.Filter) -> [Search.Result] {
        var searchArray = [Search.Result]()
        for item in contentItems {
            switch item.format {
            case .audio:
                searchArray.append(Search.resultFrom(item, filter: filter, displayType: .audio))
            case .video:
                searchArray.append(Search.resultFrom(item, filter: filter, displayType: .video))
            case .pdf:
                searchArray.append(Search.resultFrom(item, filter: filter, displayType: .pdf))
            default:
                searchArray.append(Search.resultFrom(item, filter: filter, displayType: .tool))
            }
        }

        return searchArray
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
        // TODO: report search result.
    }

    func suggestions() -> SearchSuggestions {
        return SearchSuggestions(header: ScreenTitleService.main.searchSuggestionsHeader(),
                                 suggestions: ScreenTitleService.main.searchSuggestions())
    }

    func contentItem(for searchResult: Search.Result, _ completion: @escaping (QDMContentItem?) -> Void) {
        guard let contentItemID = searchResult.contentItemID else {
            DispatchQueue.main.async {
                completion(nil)
            }
            return
        }
        qot_dal.ContentService.main.getContentItemById(contentItemID) { (item) in
            completion(item)
        }
    }
}
