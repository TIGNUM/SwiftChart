//
//  SearchProtocols.swift
//  QOT
//
//  Created by karmic on 08.03.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation
import qot_dal

protocol SearchViewControllerInterface: class {
    func load(_ searchSuggestions: SearchSuggestions)
    func reload(_ searchResults: [Search.Result])
}

protocol SearchPresenterInterface {
    func load(_ searchSuggestions: SearchSuggestions)
    func reload(_ searchResults: [Search.Result])
}

protocol SearchInteractorInterface: Interactor {
    func didTapClose()
    func showSuggestions()
    func didChangeSearchText(searchText: String, searchFilter: Search.Filter)
    func handleSelection(searchResult: Search.Result)
    func sendUserSearchResult(contentId: Int?, contentItemId: Int?, filter: Search.Filter, query: String)
    func contentItem(for searchResult: Search.Result, _ completion: @escaping (QDMContentItem?) -> Void)
}

protocol SearchRouterInterface {
    func dismiss()
    func handleSelection(searchResult: Search.Result)
}
