//
//  ArticleInteractor.swift
//  QOT
//
//  Created by karmic on 11.04.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

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

    var sectionHeaderHeight: CGFloat {
        return worker.sectionHeaderHeight
    }

    var section: ContentSection {
        return worker.section
    }

    var sectionNeedsLine: Bool {
        return worker.sectionNeedsLine
    }

    var relatedArticles: [Article.RelatedArticleWhatsHot] {
        return worker.relatedArticlesWhatsHot
    }

    var audioItem: Article.Item? {
        return worker.audioArticleItem
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

    var shouldHideTopBar: Bool {
        return worker.isTopBarHidden
    }

    func relatedArticle(at indexPath: IndexPath) -> Article.RelatedArticleWhatsHot? {
        return worker.relatedArticle(at: indexPath)
    }

    func articleItem(at indexPath: IndexPath) -> Article.Item? {
        return worker.articleItem(at: indexPath)
    }

    func markArticleAsRead(_ read: Bool, completion: @escaping () -> Void) {
        worker.markArticleAsRead(read, completion: completion)
    }

    func isRead(completion:@escaping (_ read: Bool) -> Void) {
        worker.isRead(completion: completion)
    }

    func itemCount(in section: Int) -> Int {
        return worker.itemCount(in: section)
    }

    func headerTitle(for section: Int) -> String? {
        return worker.headerTitle(for: section)
    }

    func didTapLink(_ url: URL) {
        router.didTapLink(url)
    }

    func showRelatedArticle(remoteID: Int) {
        worker = ArticleWorker(selectedID: remoteID)
        worker.interactor = self
        presenter.setupArticleHeader(header: worker.articleHeader)
        presenter.reloadData()
    }

    var whatsHotShareable: WhatsHotShareable {
        return worker.whatsHotShareable
    }

    func dataUpdated() {
        presenter.setupArticleHeader(header: worker.articleHeader)
        presenter.reloadData()
        presenter.updateBookmark(worker.bookmark != nil)
        presenter.dataUpdated()
    }

    func toggleBookmark() {
        presenter.updateBookmark(worker.toggleBookmark())
    }
}
