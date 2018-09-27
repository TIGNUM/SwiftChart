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
import AVFoundation

final class ArticleContentItemCoordinator: ParentCoordinator {

    private let services: Services
    private var articleHeader: ArticleCollectionHeader?
    private let topTabBarTitle: String?
    private var selectedContent: ContentCollection?
    private var viewModel: ArticleItemViewModel
    private let rootViewController: UIViewController
    private let shouldPush: Bool
    private let isSearch: Bool
    private let guideItem: Guide.Item?
    private var avPlayerObserver: AVPlayerObserver?
    let pageName: PageName
    var children: [Coordinator] = []
    var topTabBarController: UINavigationController?
    var fullViewController: ArticleItemViewController

    init?(pageName: PageName,
          root: UIViewController,
          services: Services,
          contentCollection: ContentCollection?,
          articleHeader: ArticleCollectionHeader? = nil,
          topTabBarTitle: String?,
          backgroundImage: UIImage? = nil,
          shouldPush: Bool = true,
          isSearch: Bool = false,
          contentInsets: UIEdgeInsets = UIEdgeInsets(top: 53, left: 0, bottom: 0, right: 0),
          guideItem: Guide.Item? = nil) {
        guard let contentCollection = contentCollection else { return nil }
        self.pageName = pageName
        self.rootViewController = root
        self.services = services
        self.articleHeader = articleHeader
        self.selectedContent = contentCollection
        self.topTabBarTitle = topTabBarTitle
        self.shouldPush = shouldPush
        self.isSearch = isSearch
        self.guideItem = guideItem
        let articleItems = Array(contentCollection.articleItems)
        viewModel = ArticleItemViewModel(services: services,
                                         items: articleItems,
                                         contentCollection: contentCollection,
                                         articleHeader: articleHeader,
                                         backgroundImage: backgroundImage)
        fullViewController = ArticleItemViewController(pageName: pageName,
                                                       viewModel: viewModel,
                                                       guideItem: guideItem,
                                                       contentInsets: contentInsets,
                                                       fadeMaskLocation: .top)
        fullViewController.title = topTabBarTitle
        fullViewController.delegate = self

        if shouldPush == false {
            topTabBarController = UINavigationController(withPages: [fullViewController],
                                                         topBarDelegate: self,
                                                         leftButton: UIBarButtonItem(withImage: R.image.ic_close()))
        }
    }

    func start() {
        guard selectedContent != nil else { return }
        if isSearch == true {
            rootViewController.pushToStart(childViewController: fullViewController)
        } else if shouldPush == false, let navigationController = topTabBarController {
            rootViewController.present(navigationController, animated: true)
        } else {
            rootViewController.pushToStart(childViewController: fullViewController)
        }

        // FIXME: Add page tracking
    }
}

// MARK: - TopNavigationBarDelegate

extension ArticleContentItemCoordinator: NavigationItemDelegate {

    func navigationItem(_ navigationItem: NavigationItem, leftButtonPressed button: UIBarButtonItem) {
        topTabBarController?.dismiss(animated: true, completion: nil)
    }

    func navigationItem(_ navigationItem: NavigationItem, middleButtonPressedAtIndex index: Int, ofTotal total: Int) {}

    func navigationItem(_ navigationItem: NavigationItem, rightButtonPressed button: UIBarButtonItem) {}
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

        articleHeader = ArticleCollectionHeader(content: selectedArticle)
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

        let playerViewController = viewController.stream(videoURL: url)
        if let playerItem = playerViewController.player?.currentItem {
            avPlayerObserver = AVPlayerObserver(playerItem: playerItem)
            avPlayerObserver?.onStatusUpdate { (player) in
                if playerItem.error != nil {
                    playerViewController.presentNoInternetConnectionAlert(in: playerViewController)
                }
            }
        }
    }
}
