//
//  ArticlePresenter.swift
//  QOT
//
//  Created by karmic on 11.04.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class ArticlePresenter {

    // MARK: - Properties
    private weak var viewController: ArticleViewControllerInterface?

    // MARK: - Init
    init(viewController: ArticleViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - ArticleInterface

extension ArticlePresenter: ArticlePresenterInterface {
    func setupArticleHeader(header: Article.Header) {
        viewController?.setupArticleHeader(header: header)
    }

    func setupView() {
        viewController?.setupView()
    }

    func reloadData() {
        viewController?.reloadData()
    }

    func updateBookmark(_ hasBookmark: Bool) {
        viewController?.hasBookmark(hasBookmark)
    }

    func dataUpdated() {
        viewController?.dataUpdated()
    }

    func setTopBarButtonItems(isShareable: Bool, hasBookMarkItem: Bool) {
        viewController?.setTopBarButtonItems(isShareable: isShareable, hasBookMarkItem: hasBookMarkItem)
    }

    func showDestinationAlert() {
        viewController?.showDestinationAlert()
    }

    func showBookmarkSelectionViewController(with contentId: Int, _ completion: @escaping (Bool) -> Void) {
        guard let viewController = R.storyboard.bookMarkSelection.bookMarkSelectionViewController() else { return }
        let config = BookMarkSelectionConfigurator.make(contentId: contentId, contentType: .CONTENT)
        config(viewController, completion)
        self.viewController?.present(viewController)
    }

    func refreshBottomNavigationItems() {
        viewController?.refreshBottomNavigationItems()
    }
    func trackPage() {
        viewController?.trackPage()
    }
}
