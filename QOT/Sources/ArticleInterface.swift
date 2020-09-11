//
//  ArticleInterface.swift
//  QOT
//
//  Created by karmic on 11.04.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

protocol ArticleViewControllerInterface: class {
    func setupView()
    func setupArticleHeader(header: Article.Header)
    func reloadData()
    func hasBookmark(_ hasBookmark: Bool)
    func dataUpdated()
    func showDestinationAlert()
    func refreshBottomNavigationItems()
    func trackPage()
    func setTopBarButtonItems(isShareable: Bool, hasBookMarkItem: Bool)
    func present(_ viewController: UIViewController)
}

protocol ArticlePresenterInterface {
    func setupView()
    func setupArticleHeader(header: Article.Header)
    func reloadData()
    func updateBookmark(_ hasBookmark: Bool)
    func dataUpdated()
    func setTopBarButtonItems(isShareable: Bool, hasBookMarkItem: Bool)
    func showDestinationAlert()
    func showBookmarkSelectionViewController(with contentId: Int, _ completion: @escaping (Bool) -> Void)
    func refreshBottomNavigationItems()
    func trackPage()
}

protocol ArticleInteractorInterface: class, Interactor {
    var alwaysHideTopBar: Bool { get }
    var section: ContentSection { get }
    var sectionCount: Int { get }
    var sectionHeaderHeight: CGFloat { get }
    var sectionNeedsLine: Bool { get }
    var relatedArticles: [Article.RelatedArticleWhatsHot] { get }
    var audioItem: Article.Item? { get }
    var categoryTitle: String { get }
    var title: String { get }
    var remoteID: Int { get }
    var audioURL: URL? { get }
    var isShareable: Bool { get }
    var shouldHideBookmarkItem: Bool { get }
    var shouldHideTopBar: Bool { get }
    func itemCount(in section: Int) -> Int
    func headerTitle(for section: Int) -> String?
    func relatedArticle(at indexPath: IndexPath) -> Article.RelatedArticleWhatsHot?
    func articleItem(at indexPath: IndexPath) -> Article.Item?
    func contactSupportAttributtedString() -> NSAttributedString
    func isSectionSupport() -> Bool
    func openEmailComposer()
    func markArticleAsRead(_ read: Bool, completion: @escaping () -> Void)
    func isRead(completion: @escaping (_ read: Bool) -> Void)
    func showRelatedArticle(remoteID: Int)
    var whatsHotShareable: WhatsHotShareable { get }
    func dataUpdated()
    func toggleBookmark()
    func showDestinationAlert()
}

protocol ArticleRouterInterface: BaseRouterInterface {}
