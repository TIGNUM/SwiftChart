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
            didTapPDF(withURL: url, in: searchViewController, title: searchResult.title, itemID: searchResult.contentItemID ?? 0)
        }
        if let section = searchResult.section {
            switch section {
            case .learnStrategy,
                 .learnWhatsHot,
                 .library,
                 .tools:
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

    func didTapPDF(withURL url: URL, in viewController: SearchViewController, title: String, itemID: Int) {
        let storyboard = UIStoryboard(name: "PDFReaderViewController", bundle: nil)
        guard let navigationController = storyboard.instantiateInitialViewController() as? UINavigationController else {
            return
        }
        guard let readerViewController = navigationController.viewControllers.first as? PDFReaderViewController else {
            return
        }
        let pdfReaderConfigurator = PDFReaderConfigurator.make(contentItemID: itemID, title: title, url: url)
        pdfReaderConfigurator(readerViewController)
        viewController.present(navigationController, animated: true, completion: nil)
    }
}
