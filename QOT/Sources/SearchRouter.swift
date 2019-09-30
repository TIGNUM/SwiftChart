//
//  SearchRouter.swift
//  QOT
//
//  Created by karmic on 08.03.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class SearchRouter {

    private weak var searchViewController: SearchViewController?

    init(searchViewController: SearchViewController) {
        self.searchViewController = searchViewController
    }
}

// MARK: - SearchPresenterInterface

extension SearchRouter: SearchRouterInterface {

    func handleSelection(searchResult: Search.Result) {
        if searchResult.displayType == .pdf, let url = searchResult.mediaURL {
            searchViewController?.showPDFReader(withURL: url, title: searchResult.title, itemID: searchResult.contentItemID ?? 0)
        }
        if let contentItemID = searchResult.contentItemID, let launchURL = URLScheme.contentItem.launchURLWithParameterValue(String(contentItemID)) {
            UIApplication.shared.open(launchURL, options: [:], completionHandler: nil)
        } else if let contentCollectionID = searchResult.contentID {
            if searchResult.section == .LearnStrategies {
                presentStrategyList(selectedStrategyID: contentCollectionID)
            } else if searchResult.section == .QOTLibrary {
                presentToolsItems(selectedToolID: contentCollectionID)
            } else if let launchURL = URLScheme.randomContent.launchURLWithParameterValue(String(contentCollectionID)) {
                UIApplication.shared.open(launchURL, options: [:], completionHandler: nil)
            }
        }
    }

    func dismiss() {
        searchViewController?.dismiss(animated: true, completion: nil)
    }
}

// MARK: - Private

private extension SearchRouter {

    func link(with identifier: Int?, urlFormat: String) -> URL? {
        guard let identifier = identifier else { return nil }
        return URL(string: String(format: urlFormat, identifier))
    }

    func presentArticle(with link: URL) {
        LaunchHandler().process(url: link)
    }

    func presentStrategyList(selectedStrategyID: Int) {
        let identifier = R.storyboard.main.qotArticleViewController.identifier
        if let controller = R.storyboard.main()
            .instantiateViewController(withIdentifier: identifier) as? ArticleViewController {
            ArticleConfigurator.configure(selectedID: selectedStrategyID, viewController: controller)
            searchViewController?.present(controller, animated: true, completion: nil)
        }
    }

    func presentToolsItems(selectedToolID: Int?) {
        if let controller = R.storyboard.tools().instantiateViewController(withIdentifier: R.storyboard.tools.qotToolsItemsViewController.identifier) as? ToolsItemsViewController {
            ToolsItemsConfigurator.make(viewController: controller, selectedToolID: selectedToolID)
            searchViewController?.present(controller, animated: true, completion: nil)
        }
    }
}
