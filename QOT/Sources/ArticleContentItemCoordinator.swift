//
//  ArticleContentItemCoordinator.swift
//  QOT
//
//  Created by karmic on 22.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

struct ArticleCollectionHeader {
    let articleTitle: String
    let articleSubTitle: String
    let articleDate: String
    let articleDuration: String
    let articleContentCollection: ArticleContentCollection
}

final class ArticleContentItemCoordinator: ParentCoordinator {

    fileprivate let rootVC: UIViewController
    fileprivate let services: Services
    fileprivate let eventTracker: EventTracker
    fileprivate let articleHeader: ArticleCollectionHeader
    fileprivate var selectedContent: ArticleContentCollection
    fileprivate var relatedArticles: DataProvider<ArticleContentCollection>
    fileprivate var fullViewController: ArticleItemViewController
    fileprivate var audioViewController: ArticleItemViewController
    fileprivate var videoViewController: ArticleItemViewController
    fileprivate var slideShowViewController: ArticleItemViewController
    fileprivate var viewModel: ArticleItemViewModel
    var children: [Coordinator] = []

    init(
        root: LearnContentListViewController,
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
            self.fullViewController = ArticleItemViewController()
            self.audioViewController = ArticleItemViewController()
            self.videoViewController = ArticleItemViewController()
            self.slideShowViewController = ArticleItemViewController()
    }

    func start() {
//        let topTabBarControllerItem = TopTabBarController.Item(
//            controllers: [fullViewController, bulletViewController, audioViewController],
//            themes: [.light, .light, .light],
//            titles: [
//                R.string.localized.learnContentItemTitleFull(),
//                R.string.localized.learnContentItemTitleBullets(),
//                R.string.localized.learnContentItemTitleAudio()
//            ]
//        )
//        let topTabBarController = TopTabBarController(
//            item: topTabBarControllerItem,
//            leftIcon: R.image.ic_minimize(),
//            learnHeaderTitle: selectedContent.title,
//            learnHeaderSubTitle: categoryTitle
//        )

//        fullViewController.serviceDelegate = services
//        fullViewController.delegate = self
//        bulletViewController.delegate = self
//        audioViewController.delegate = self
//        topTabBarController.modalTransitionStyle = .crossDissolve
//        topTabBarController.modalPresentationStyle = .custom
//        topTabBarController.delegate = self
//        topTabBarController.learnContentItemViewControllerDelegate = self
//        topTabBarControllerDelegate = topTabBarController
//        rootVC.present(topTabBarController, animated: true)
        // FIXME: Add page tracking
    }
}
