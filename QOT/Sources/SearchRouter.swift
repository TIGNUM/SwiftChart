//
//  SearchRouter.swift
//  QOT
//
//  Created by karmic on 08.03.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

final class SearchRouter {

    private let searchViewController: SearchViewController

    init(searchViewController: SearchViewController) {
        self.searchViewController = searchViewController
    }
}

// MARK: - SearchPresenterInterface

extension SearchRouter: SearchRouterInterface {

    func handleSelection(searchResult: Search.Result) {
        guard let section = searchResult.section else { return }
        switch section {
        case .learnStrategy:
            if let link = link(with: searchResult.contentID, urlFormat: "qot://random-content?contentID=%d") {
                presentArticle(with: link)
            }
        case .learnWhatsHot,
             .library,
             .tools:
            if let link = link(with: searchResult.contentID, urlFormat: "qot://contentItem?contentID=%d") {
                presentArticle(with: link)
            }
        default: return
        }
    }

    func dismiss() {
        searchViewController.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Private

private extension SearchRouter {

    func link(with identifier: Int?, urlFormat: String) -> URL? {
        guard let identifier = identifier else { return nil }
        return URL(string: String(format: urlFormat, identifier))
    }

    func presentArticle(with link: URL) {
        LaunchHandler().process(url: link, searchViewController: searchViewController)
    }
}
