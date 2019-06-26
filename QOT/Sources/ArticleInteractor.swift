//
//  ArticleInteractor.swift
//  QOT
//
//  Created by karmic on 11.04.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class ArticleInteractor {

    // MARK: - Properties

    private var worker: ArticleWorker
    private let presenter: ArticlePresenterInterface
    private let router: ArticleRouterInterface

    // MARK: - Init

    init(worker: ArticleWorker,
        presenter: ArticlePresenterInterface,
        router: ArticleRouterInterface) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
    }

    // MARK: - Interactor

    func viewDidLoad() {
        presenter.setupView()
        presenter.setupArticleHeader(header: worker.articleHeader)
    }
}

// MARK: - ArticleInteractorInterface

extension ArticleInteractor: ArticleInteractorInterface {
    var isShareable: Bool {
        return worker.isShareable
    }

    var sectionCount: Int {
        return worker.sectionCount
    }

    var relatedArticles: [Article.RelatedArticleWhatsHot] {
        return worker.relatedArticlesWhatsHot
    }

    var audioItem: Article.Item? {
        return worker.audioItem
    }

    var categoryTitle: String {
        return worker.categoryTitle
    }

    var title: String {
        return worker.title
    }

    var remoteID: Int {
        return worker.remoteID
    }

    var audioURL: URL? {
        return worker.audioURL
    }

    func relatedArticle(at indexPath: IndexPath) -> Article.RelatedArticleWhatsHot {
        return worker.relatedArticle(at: indexPath)
    }

    func articleItem(at indexPath: IndexPath) -> Article.Item? {
        return worker.articleItem(at: indexPath)
    }

    func markArticleAsRead() {
        worker.markArticleAsRead()
    }

    func itemCount(in section: Int) -> Int {
        return worker.itemCount(in: section)
    }

    func didTapLink(_ url: URL) {
        router.didTapLink(url)
    }

    func showRelatedArticle(remoteID: Int) {
        let services = worker.services
        worker = ArticleWorker(services: services, selectedID: remoteID)
        presenter.setupArticleHeader(header: worker.articleHeader)
        presenter.reloadData()
    }

    var whatsHotShareable: WhatsHotShareable {
        return worker.whatsHotShareable
    }
}
