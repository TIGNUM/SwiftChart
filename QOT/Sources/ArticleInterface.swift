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
    func reloadData()
    func hasBookmark(_ hasBookmark: Bool)
}

protocol ArticlePresenterInterface {
    func setupView()
    func setupArticleHeader(header: Article.Header)
    func reloadData()
    func updateBookmark(_ hasBookmark: Bool)
}

protocol ArticleInteractorInterface: class, Interactor {
    var sectionCount: Int { get }
    var relatedArticles: [Article.RelatedArticleWhatsHot] { get }
    var audioItem: Article.Item? { get }
    var categoryTitle: String { get }
    var title: String { get }
    var remoteID: Int { get }
    var audioURL: URL? { get }
    var isShareable: Bool { get }
    func itemCount(in section: Int) -> Int
    func relatedArticle(at indexPath: IndexPath) -> Article.RelatedArticleWhatsHot?
    func articleItem(at indexPath: IndexPath) -> Article.Item?
    func markArticleAsRead()
    func didTapLink(_ url: URL)
    func showRelatedArticle(remoteID: Int)
    var whatsHotShareable: WhatsHotShareable { get }
    func dataUpdated()
    func toggleBookmark()
}

protocol ArticleRouterInterface {
    func didTapLink(_ url: URL)
}
