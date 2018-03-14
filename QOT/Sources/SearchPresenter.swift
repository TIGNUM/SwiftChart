//
//  SearchPresenter.swift
//  QOT
//
//  Created by karmic on 08.03.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

final class SearchPresenter {

    private weak var viewController: SearchViewControllerInterface?

    init(viewController: SearchViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - SearchPresenterInterface

extension SearchPresenter: SearchPresenterInterface {

    func reload(_ searchResults: [Search.Result]) {
        viewController?.reload(searchResults)
    }
}
