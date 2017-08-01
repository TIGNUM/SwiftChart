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
    fileprivate let articleHeader: ArticleCollectionHeader?
    fileprivate let topTabBarTitle: String?
    fileprivate var selectedContent: ContentCollection?
    fileprivate var fullViewController: ArticleItemViewController
    fileprivate var audioViewController: ArticleItemViewController
    fileprivate var viewModel: ArticleItemViewModel
    fileprivate var topTabBarController: UINavigationController!
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
                                         articleHeader: articleHeader)
        
        fullViewController = ArticleItemViewController(viewModel: viewModel)
        audioViewController = ArticleItemViewController(viewModel: viewModel)
        
        let tabs = TabType.allTabs(for: Array(articleItems))
        var controllers = [UIViewController]()
        tabs.forEach { (tabType: TabType) in
            switch tabType {
            case .full:
                controllers.append(fullViewController)
                fullViewController.title = R.string.localized.learnContentItemTitleFull()
            case .audio:
                controllers.append(audioViewController)
                audioViewController.title = R.string.localized.learnContentItemTitleAudio()
            case .bullets:
                return
            }
        }
        
        let leftButton = UIBarButtonItem(withImage: R.image.ic_minimize())
        topTabBarController = UINavigationController(withPages: controllers, topBarDelegate: self, pageDelegate: self, leftButton: leftButton)
        topTabBarController.modalTransitionStyle = .crossDissolve
        topTabBarController.modalPresentationStyle = .custom
        
        fullViewController.delegate = self
        audioViewController.delegate = self
    }

    func start() {
        guard selectedContent != nil else {
            return
        }
        rootVC.present(topTabBarController, animated: true)
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
        audioViewController.reloadArticles(viewModel: viewModel)
    }
}

// MARK: - TopNavigationBarDelegate

extension ArticleContentItemCoordinator: TopNavigationBarDelegate {
    func topNavigationBar(_ navigationBar: TopNavigationBar, leftButtonPressed button: UIBarButtonItem) {
        topTabBarController.dismiss(animated: true, completion: nil)
    }
    
    func topNavigationBar(_ navigationBar: TopNavigationBar, middleButtonPressed button: UIButton, withIndex index: Int, ofTotal total: Int) {
        guard let pageViewController = topTabBarController.viewControllers.first as? PageViewController else {
            return
        }
        pageViewController.setPageIndex(index, animated: true)
    }
    
    func topNavigationBar(_ navigationBar: TopNavigationBar, rightButtonPressed button: UIBarButtonItem) {
    }
}

// MARK: - PageViewControllerDelegate

extension ArticleContentItemCoordinator: PageViewControllerDelegate {
    func pageViewController(_ controller: UIPageViewController, didSelectPageIndex index: Int) {
        guard let navigationController = controller.navigationController, let topNavigationBar = navigationController.navigationBar as? TopNavigationBar else {
            return
        }
        topNavigationBar.setIndicatorToButtonIndex(index)
    }
}
