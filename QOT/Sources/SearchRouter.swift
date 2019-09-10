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
        if searchResult.displayType == .pdf, let url = searchResult.mediaURL {
            searchViewController.showPDFReader(withURL: url, title: searchResult.title, itemID: searchResult.contentItemID ?? 0)
        }
        if let section = searchResult.section {
            switch section {
            case .LearnStrategies,
                 .WhatsHot,
                 .QOTLibrary,
                 .Tools:
                if let link = link(with: searchResult.contentID, urlFormat: "qot://random-content?contentID=%d") {
                    presentArticle(with: link)
                }
            default: return
            }
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
