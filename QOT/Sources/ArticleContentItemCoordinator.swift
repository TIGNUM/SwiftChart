//
//  ArticleContentItemCoordinator.swift
//  QOT
//
//  Created by karmic on 22.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import RealmSwift

struct ArticleCollectionHeader {

    let articleTitle: String

    let articleSubTitle: String

    let articleDate: String

    let articleDuration: String

    let articleContentCollection: ContentCollection
}

final class ArticleContentItemCoordinator: ParentCoordinator {

    fileprivate let rootVC: UIViewController
    fileprivate let services: Services
    fileprivate let eventTracker: EventTracker
    fileprivate let articleHeader: ArticleCollectionHeader
    fileprivate var selectedContent: ContentCollection
    fileprivate var relatedArticles: AnyRealmCollection<ContentCollection>
    fileprivate var fullViewController: ArticleItemViewController
    fileprivate var audioViewController: ArticleItemViewController
    fileprivate var viewModel: ArticleItemViewModel
    var children: [Coordinator] = []

    init(
        root: UIViewController,
        services: Services,
        eventTracker: EventTracker,
        articleHeader: ArticleCollectionHeader) {
            self.rootVC = root
            self.services = services
            self.eventTracker = eventTracker
            self.articleHeader = articleHeader
            self.selectedContent = articleHeader.articleContentCollection
            self.relatedArticles = services.articleService.relatedArticles(for: selectedContent)
            self.viewModel = ArticleItemViewModel(items: selectedContent.articleItems,
                                                  articleHeader: articleHeader,
                                                  relatedArticles: relatedArticles)
            self.fullViewController = ArticleItemViewController(viewModel: viewModel)
            self.audioViewController = ArticleItemViewController(viewModel: viewModel)
    }

    func start() {
        let tabs = TabType.allTabs(for: Array(selectedContent.articleItems))
        var controllers = [UIViewController]()
        var titles = [String]()
        var themes = [Theme]()

        tabs.forEach { (tabType: TabType) in
            switch tabType {
            case .full:
                controllers.append(fullViewController)
                titles.append(R.string.localized.learnContentItemTitleFull())
                themes.append(.dark)
            case .audio:
                controllers.append(audioViewController)
                titles.append(R.string.localized.learnContentItemTitleAudio())
                themes.append(.dark)
            case .bullets: return
            }
        }

        let topTabBarControllerItem = TopTabBarController.Item(
            controllers: controllers,
            themes: themes,
            titles: titles,
            header: articleHeader
        )

        let topTabBarController = TopTabBarController(
            item: topTabBarControllerItem,
            leftIcon: R.image.ic_minimize()
        )

        fullViewController.delegate = self
        audioViewController.delegate = self
        topTabBarController.modalTransitionStyle = .crossDissolve
        topTabBarController.modalPresentationStyle = .custom
        topTabBarController.delegate = self
        rootVC.present(topTabBarController, animated: true)
        // FIXME: Add page tracking
    }
}

// MARK: - ArticleItemViewControllerDelegate

extension ArticleContentItemCoordinator: ArticleItemViewControllerDelegate {

    func didSelectRelatedArticle(selectedArticle: ContentCollection, form viewController: ArticleItemViewController) {
        self.selectedContent = selectedArticle
        relatedArticles = services.articleService.relatedArticles(for: selectedArticle)
        viewModel = ArticleItemViewModel(items: selectedContent.articleItems,
                                              articleHeader: articleHeader,
                                              relatedArticles: relatedArticles)
        fullViewController.reloadArticles(viewModel: viewModel)
        audioViewController.reloadArticles(viewModel: viewModel)
    }
}

// MARK: - TopTabBarDelegate

extension ArticleContentItemCoordinator: TopTabBarDelegate {

    func didSelectItemAtIndex(index: Int, sender: TopTabBarController) {
        print("didSelectItemAtIndex: at index:", index)
    }

    func didSelectLeftButton(sender: TopTabBarController) {
        sender.dismiss(animated: true, completion: nil)
    }

    func didSelectRightButton(sender: TopTabBarController) {
        print("didSelectItemAtIndex")
    }
}
