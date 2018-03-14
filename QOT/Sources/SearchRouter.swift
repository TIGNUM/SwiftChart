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
            if let url = URL(string: String(format: "qot://random-content?contentID=%d", searchResult.contentID)) {
                LaunchHandler().process(url: url)
            }
        case .learnWhatsHot,
             .library,
             .tools:
            if let url = URL(string: String(format: "qot://contentItem?contentID=%d", searchResult.contentID)) {
                LaunchHandler().process(url: url, searchViewController: searchViewController)
            }
        default: return
        }
    }

    func dismiss() {
        searchViewController.dismiss(animated: true, completion: nil)
    }
}
