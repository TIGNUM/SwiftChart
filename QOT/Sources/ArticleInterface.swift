//
//  ArticleInterface.swift
//  QOT
//
//  Created by karmic on 11.04.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

protocol ArticleViewControllerInterface: class {
    func setupView()
    func setupArticleHeader(header: Article.Header)
}

protocol ArticlePresenterInterface {
    func setupView()
    func setupArticleHeader(header: Article.Header)
}

protocol ArticleInteractorInterface: Interactor {
    var sectionCount: Int { get }
    var relatedArticles: [Article.RelatedArticle] { get }
    var audioItem: Article.Item? { get }
    var categoryTitle: String { get }
    var title: String { get }
    var remoteID: Int { get }
    var audioURL: URL? { get }
    func itemCount(in section: Int) -> Int
    func relatedArticle(at indexPath: IndexPath) -> Article.RelatedArticle
    func articleItem(at indexPath: IndexPath) -> Article.Item
    func markArticleAsRead()
    func didTapLink(_ url: URL)
}

protocol ArticleRouterInterface {
    func didTapLink(_ url: URL)
}
