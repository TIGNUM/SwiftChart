//
//  SearchInteractor.swift
//  QOT
//
//  Created by karmic on 08.03.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

final class SearchInteractor {

    let worker: SearchWorker
    let router: SearchRouterInterface
    let presenter: SearchPresenterInterface

    init(worker: SearchWorker, router: SearchRouterInterface, presenter: SearchPresenterInterface) {
        self.worker = worker
        self.router = router
        self.presenter = presenter
    }
}

// MARK: - SearchInteractorInterface

extension SearchInteractor: SearchInteractorInterface {

    func showSuggestions() {
        let suggestions = worker.suggestions()
        presenter.load(suggestions)
    }

    func sendUserSearchResult(contentId: Int?, contentItemId: Int?, filter: Search.Filter, query: String) {
        if query.isEmpty == false {
            worker.sendUserSearchResult(contentId: contentId, contentItemId: contentItemId, filter: filter, query: query)
        }
    }

    func handleSelection(searchResult: Search.Result) {
        router.handleSelection(searchResult: searchResult)
    }

    func didTapClose() {
        router.dismiss()
    }

    func didChangeSearchText(searchText: String, searchFilter: Search.Filter) {
        let searchResults = worker.search(searchText, searchFilter: searchFilter)
        presenter.reload(searchResults)
    }

    func contentItem(for searchResult: Search.Result) -> ContentItem? {
        return worker.contentItem(for: searchResult)
    }
}
