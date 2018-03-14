//
//  SearchProtocols.swift
//  QOT
//
//  Created by karmic on 08.03.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

protocol SearchViewControllerInterface: class {
    func reload(_ searchResults: [Search.Result])
}

protocol SearchPresenterInterface {
    func reload(_ searchResults: [Search.Result])
}

protocol SearchInteractorInterface: Interactor {
    func didTapClose()
    func didChangeSearchText(searchText: String, searchFilter: Search.Filter)
    func handleSelection(searchResult: Search.Result)
}

protocol SearchRouterInterface {
    func dismiss()
    func handleSelection(searchResult: Search.Result)
}
