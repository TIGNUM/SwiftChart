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
}
