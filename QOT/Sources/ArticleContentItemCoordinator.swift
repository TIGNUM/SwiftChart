//
//  ArticleContentItemCoordinator.swift
//  QOT
//
//  Created by karmic on 22.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import AVKit
import RealmSwift
import SafariServices
import AVFoundation

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
    fileprivate let articleHeader: ArticleCollectionHeader?
    fileprivate let topTabBarTitle: String?
    fileprivate var selectedContent: ContentCollection?
    fileprivate var fullViewController: ArticleItemViewController
    fileprivate var viewModel: ArticleItemViewModel
    var children: [Coordinator] = []

    init?(root: UIViewController, services: Services, contentCollection: ContentCollection?, articleHeader: ArticleCollectionHeader?, topTabBarTitle: String?) {
        guard let contentCollection = contentCollection else {
            return nil
        }
        
        self.rootVC = root
        self.services = services
        self.articleHeader = articleHeader
        self.selectedContent = contentCollection
        self.topTabBarTitle = topTabBarTitle
        let articleItems = Array(contentCollection.articleItems)
        viewModel = ArticleItemViewModel(services: services,
                                         items: articleItems,
                                         contentCollection: contentCollection,
                                         articleHeader: articleHeader
                    )
        fullViewController = ArticleItemViewController(viewModel: viewModel)
        fullViewController.modalTransitionStyle = .crossDissolve
        fullViewController.modalPresentationStyle = .custom
        fullViewController.title = topTabBarTitle
        fullViewController.delegate = self
    }

    func start() {
        guard selectedContent != nil else {
            return
        }
        rootVC.present(fullViewController, animated: true)
        // FIXME: Add page tracking
    }
}

// MARK: - ArticleItemViewControllerDelegate

extension ArticleContentItemCoordinator: ArticleItemViewControllerDelegate {

    func didSelectRelatedArticle(selectedArticle: ContentCollection, form viewController: ArticleItemViewController) {
        self.selectedContent = selectedArticle
        viewModel = ArticleItemViewModel(services: services,
                                         items: Array(selectedArticle.articleItems),
                                         contentCollection: selectedArticle,
                                         articleHeader: articleHeader)

        fullViewController.reloadArticles(viewModel: viewModel)
    }

    func didTapLink(_ url: URL, in viewController: ArticleItemViewController) {
        if url.scheme == "mailto" {
            UIApplication.shared.open(url)
        } else {
            let webViewController = SFSafariViewController(url: url)
            viewController.present(webViewController, animated: true, completion: nil)
        }
    }

    func didTapClose(in viewController: ArticleItemViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }

    func didTapMedia(withURL url: URL, in viewController: ArticleItemViewController) {
        let playerItem = AVPlayerItem(url: url)
        let player = AVPlayer(playerItem: playerItem)
        player.volume = 1.0
        player.play()

        let playerVC = AVPlayerViewController()
        playerVC.player = player

        viewController.present(playerVC, animated: true, completion: nil)

    }
}
