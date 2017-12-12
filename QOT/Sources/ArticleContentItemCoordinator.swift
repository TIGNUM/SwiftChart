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

final class ArticleContentItemCoordinator: ParentCoordinator {

    private let services: Services
    private var articleHeader: ArticleCollectionHeader?
    private let topTabBarTitle: String?
    private var selectedContent: ContentCollection?
    private var fullViewController: ArticleItemViewController
    private var viewModel: ArticleItemViewModel
    private var topTabBarController: UINavigationController?
    private let rootViewController: UIViewController
    private let shouldPush: Bool
    let pageName: PageName
    var children: [Coordinator] = []

    init?(pageName: PageName,
          root: UIViewController,
          services: Services,
          contentCollection: ContentCollection?,
          articleHeader: ArticleCollectionHeader? = nil,
          topTabBarTitle: String?,
          backgroundImage: UIImage? = nil,
          shouldPush: Bool = true,
          contentInsets: UIEdgeInsets = UIEdgeInsets(top: 53, left: 0, bottom: 0, right: 0)) {
        guard let contentCollection = contentCollection else { return nil }

        self.pageName = pageName
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

        fullViewController = ArticleItemViewController(
            pageName: pageName,
            viewModel: viewModel,
            contentInsets: contentInsets
        )
        fullViewController.title = topTabBarTitle
        fullViewController.delegate = self

        if shouldPush == false {
            topTabBarController = UINavigationController(withPages: [fullViewController],
                                                         topBarDelegate: self,
                                                         leftButton: UIBarButtonItem(withImage: R.image.ic_minimize()))
        }
    }

    func start() {
        guard selectedContent != nil else { return }

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

        if selectedArticle.section == Database.Section.learnStrategy.rawValue,
            let contentID = selectedArticle.remoteID.value,
            let categoryID = selectedArticle.categoryIDs.first?.value {
            AppDelegate.current.appCoordinator.presentLearnContentItems(contentID: contentID, categoryID: categoryID)
            return
        }

        articleHeader = ArticleCollectionHeader(contentCollection: selectedArticle)
        viewModel = ArticleItemViewModel(services: services,
                                         items: Array(selectedArticle.articleItems),
                                         contentCollection: selectedArticle,
                                         articleHeader: articleHeader)
        fullViewController.reloadArticles(viewModel: viewModel)
    }

    func didTapLink(_ url: URL, in viewController: ArticleItemViewController) {
        if url.scheme == "mailto" && UIApplication.shared.canOpenURL(url) == true {
            UIApplication.shared.open(url)
        } else {
            do {
                viewController.present(try WebViewController(url), animated: true, completion: nil)
            } catch {
                log("Failed to open url. Error: \(error)", level: .error)
                viewController.showAlert(type: .message(error.localizedDescription))
            }
        }
    }

    func didTapClose(in viewController: ArticleItemViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }

    func didTapMedia(withURL url: URL, in viewController: ArticleItemViewController) {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        } catch let error {
            log("Error while trying to set catgeory for AVAudioSession: \(error)", level: .error)
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
