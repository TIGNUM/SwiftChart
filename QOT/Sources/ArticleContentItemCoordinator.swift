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

    fileprivate let services: Services
    fileprivate let articleHeader: ArticleCollectionHeader?
    fileprivate let topTabBarTitle: String?
    fileprivate var selectedContent: ContentCollection?
    fileprivate var fullViewController: ArticleItemViewController
    fileprivate var viewModel: ArticleItemViewModel
    fileprivate var topTabBarController: UINavigationController?
    fileprivate let rootViewController: UIViewController
    fileprivate let shouldPush: Bool
    var children: [Coordinator] = []

    init?(root: UIViewController,
          services: Services,
          contentCollection: ContentCollection?,
          articleHeader: ArticleCollectionHeader? = nil,
          topTabBarTitle: String?,
          backgroundImage: UIImage? = nil,
          shouldPush: Bool = true,
          contentInsets: UIEdgeInsets = UIEdgeInsets(top: 35, left: 0, bottom: 0, right: 0)) {

            guard let contentCollection = contentCollection else {
                return nil
            }
        
            self.rootViewController = root
            self.services = services
            self.articleHeader = articleHeader
            self.selectedContent = contentCollection
            self.topTabBarTitle = topTabBarTitle
            self.shouldPush = shouldPush
            let articleItems = Array(contentCollection.articleItems)
            viewModel = ArticleItemViewModel(services: services,
                                         items: articleItems,
                                         contentCollection: contentCollection,
                                         articleHeader: articleHeader,
                                         backgroundImage: backgroundImage
            )

            fullViewController = ArticleItemViewController(viewModel: viewModel, contentInsets: UIEdgeInsets(top: 110, left: 0, bottom: 0, right: 0))
            fullViewController.title = topTabBarTitle
            fullViewController.delegate = self

            if shouldPush == false {
                topTabBarController = UINavigationController(withPages: [fullViewController],
                                                             topBarDelegate: self,
                                                             leftButton: UIBarButtonItem(withImage: R.image.ic_minimize()))
            }
    }

    func start() {
        guard selectedContent != nil else {
            return
        }

        if shouldPush == false,
            let navigationController = topTabBarController {
                rootViewController.present(navigationController, animated: true)
        } else {
            rootViewController.pushToStart(childViewController: fullViewController)
        }

        // FIXME: Add page tracking
    }
}

// MARK: - TopNavigationBarDelegate

extension ArticleContentItemCoordinator: TopNavigationBarDelegate {

    func topNavigationBar(_ navigationBar: TopNavigationBar, leftButtonPressed button: UIBarButtonItem) {
        topTabBarController?.dismiss(animated: true, completion: nil)
    }

    func topNavigationBar(_ navigationBar: TopNavigationBar, middleButtonPressed button: UIButton, withIndex index: Int, ofTotal total: Int) {}

    func topNavigationBar(_ navigationBar: TopNavigationBar, rightButtonPressed button: UIBarButtonItem) {}
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
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        } catch let error {
            print("Error while trying to set catgeory for AVAudioSession: ", error)
        }

        let playerItem = AVPlayerItem(url: url)
        let player = AVPlayer(playerItem: playerItem)
        player.volume = 1.0
        player.play()
        let playerVC = AVPlayerViewController()
        playerVC.player = player
        viewController.present(playerVC, animated: true, completion: nil)
    }
}
