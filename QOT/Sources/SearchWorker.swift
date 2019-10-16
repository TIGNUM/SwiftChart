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
    let startDeactivated: Bool

    init(startDeactivated: Bool) {
        self.startDeactivated = startDeactivated
    }

    func search(_ searchText: String, searchFilter: Search.Filter, _ completion: @escaping ([Search.Result]) -> Void) {
        switch searchFilter {
        case .all:
            ContentService.main.getAllFor(keyword: searchText) { [weak self] (contentCollections, contentItems) in
                self?.getSearchResults(searchFilter, contentCollections, contentItems, completion)
            }
        case .read:
            ContentService.main.getAllReadablesFor(keyword: searchText) { [weak self] (contentCollections, contentItems) in
                self?.getSearchResults(searchFilter, contentCollections, contentItems, completion)
            }
        case .listen:
            ContentService.main.getAudioItemsFor(keyword: searchText) { [weak self] (contentItems) in
                self?.getSearchResults(searchFilter, nil, contentItems, completion)
            }
        case .watch:
            ContentService.main.getVideoItemsFor(keyword: searchText) { [weak self] (contentItems) in
                self?.getSearchResults(searchFilter, nil, contentItems, completion)
            }
        case .tools:
            ContentService.main.getToolsContentCollectionsFor(keyword: searchText) { [weak self] (contentCollections) in
                self?.getSearchResults(searchFilter, contentCollections, nil, completion)
            }
        }
    }

    private func getSearchResults(_ searchFilter: Search.Filter,
                                  _ contentCollections: [QDMContentCollection]? = nil,
                                  _ contentItems: [QDMContentItem]? = nil,
                                  _ completion: @escaping ([Search.Result]) -> Void) {
        let QOTGuideCategoryId = 100047 // TODO: we need to have
        var searchArray = [Search.Result]()
        if let collections = contentCollections?.filter({ $0.categoryIDs.contains(QOTGuideCategoryId) == false }) {
            if searchFilter == .tools {
                searchArray.append(contentsOf: Search.resultFrom(collections, filter: searchFilter, displayType: .tool))
            } else {
                collections.forEach { (content) in
                    if content.section == .QOTLibrary && searchFilter == .all {
                        searchArray.append(contentsOf: Search.resultFrom([content],
                                                                         filter: searchFilter,
                                                                         displayType: .files))
                    } else if content.section != .QOTLibrary {
                        searchArray.append(contentsOf: Search.articleResultFrom([content],
                                                                                filter: searchFilter,
                                                                                displayType: .article)
                        )
                    }
                }
            }
        }
        if let items = contentItems {
            searchArray.append(contentsOf: contentItemResultsFrom(contentItems: items, filter: searchFilter))
        }
        if searchFilter == .tools || searchFilter == .watch {
            searchArray.sort(by: { $0.title < $1.title })
        }
        completion(removeDuplicates(from: searchArray))
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

    private func suggestions() -> [String] {
        let keys: [AppTextKey] = [AppTextKey.search_suggestion_view_subtitle_self_image,
                                  AppTextKey.search_suggestion_view_subtitle_daily_prep,
                                  AppTextKey.search_suggestion_view_subtitle_no_excuse,
                                  AppTextKey.search_suggestion_view_subtitle_build_capacity,
                                  AppTextKey.search_suggestion_view_subtitle_sleep_ritual,
                                  AppTextKey.search_suggestion_view_subtitle_power_nap,
                                  AppTextKey.search_suggestion_view_subtitle_mindset_shifter,
                                  AppTextKey.search_suggestion_view_subtitle_reframe,
                                  AppTextKey.search_suggestion_view_subtitle_breathing,
                                  AppTextKey.search_suggestion_view_subtitle_hp_snacks,
                                  AppTextKey.search_suggestion_view_subtitle_brain_performance,
                                  AppTextKey.search_suggestion_view_subtitle_work_to_home,
                                  AppTextKey.search_suggestion_view_subtitle_travel]
        var array: [String] = []
        for key in keys {
            array.append(AppTextService.get(key))
        }
        return array
    }

    func suggestions(completion: @escaping (SearchSuggestions?) -> Void) {
        var suggestionItems: [String] = []
        ContentService.main.getContentCategory(.Search) { (searchCategory) in
            searchCategory?.contentCollections.first?.contentItems.sorted(by: {$0.sortOrder < $1.sortOrder}).forEach {(suggestionItem) in
                suggestionItems.append(suggestionItem.valueText)
            }
            completion(SearchSuggestions(header: AppTextService.get(AppTextKey.search_view_title_suggestion),
                                 suggestions: suggestions()))
        }
    }

    func contentItem(for searchResult: Search.Result, _ completion: @escaping (QDMContentItem?) -> Void) {
        guard let contentItemID = searchResult.contentItemID else {
            DispatchQueue.main.async {
                completion(nil)
            }
            return
        }
        ContentService.main.getContentItemById(contentItemID) { (item) in
            completion(item)
        }
    }
}
