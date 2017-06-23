//
//  LearnContentItemCoordinator.swift
//  QOT
//
//  Created by tignum on 3/30/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class LearnContentItemCoordinator: ParentCoordinator {
    
    fileprivate let rootVC: LearnContentListViewController
    fileprivate let services: Services
    fileprivate let eventTracker: EventTracker
    fileprivate let category: LearnContentCategory
    fileprivate var categoryTitle: String
    fileprivate var selectedContent: LearnContentCollection
    fileprivate var relatedContents: DataProvider<LearnContentCollection>
    fileprivate var recommentedContentCollections: DataProvider<LearnContentCollection>
    fileprivate var fullViewController: LearnContentItemViewController
    fileprivate var bulletViewController: LearnContentItemViewController
    fileprivate var audioViewController: LearnContentItemViewController
    fileprivate var viewModel: LearnContentItemViewModel
    weak var topTabBarControllerDelegate: TopTabBarControllerDelegate?
    var children: [Coordinator] = []
    
    init(root: LearnContentListViewController, services: Services, eventTracker: EventTracker, content: LearnContentCollection, category: LearnContentCategory) {
        self.rootVC = root
        self.services = services
        self.eventTracker = eventTracker
        self.category = category
        self.categoryTitle = category.title.capitalized
        self.selectedContent = content
        self.relatedContents = services.learnContentService.contentCollections(for: selectedContent.relatedContentIDs)
        self.recommentedContentCollections = services.learnContentService.relatedContentCollections(for: category.remoteID)
        self.viewModel = LearnContentItemViewModel(
            contentCollection: selectedContent,
            relatedContentCollections: relatedContents,
            recommentedContentCollections: recommentedContentCollections
        )
        self.fullViewController = LearnContentItemViewController(
            viewModel: viewModel,
            categoryTitle: categoryTitle,
            contentTitle: selectedContent.title,
            tabType: .full
        )
        self.bulletViewController = LearnContentItemViewController(
            viewModel: viewModel,
            categoryTitle: categoryTitle,
            contentTitle: selectedContent.title,
            tabType: .bullets
        )
        self.audioViewController = LearnContentItemViewController(
            viewModel: viewModel,
            categoryTitle: categoryTitle,
            contentTitle: selectedContent.title,
            tabType: .audio
        )
    }

    func start() {
        let topTabBarControllerItem = TopTabBarController.Item(
            controllers: [fullViewController, bulletViewController, audioViewController],
            themes: [.light, .light, .light],
            titles: [
                R.string.localized.learnContentItemTitleFull(),
                R.string.localized.learnContentItemTitleBullets(),
                R.string.localized.learnContentItemTitleAudio()
            ]
        )
        let topTabBarController = TopTabBarController(
            item: topTabBarControllerItem,
            leftIcon: R.image.ic_minimize(),
            learnHeaderTitle: selectedContent.title,
            learnHeaderSubTitle: categoryTitle
        )

        fullViewController.serviceDelegate = services
        fullViewController.delegate = self
        bulletViewController.delegate = self
        audioViewController.delegate = self
        topTabBarController.modalTransitionStyle = .crossDissolve
        topTabBarController.modalPresentationStyle = .custom
        topTabBarController.delegate = self
        topTabBarController.learnContentItemViewControllerDelegate = self
        topTabBarControllerDelegate = topTabBarController
        rootVC.present(topTabBarController, animated: true)
        // FIXME: Add page tracking
    }    
}

extension LearnContentItemCoordinator: TopTabBarDelegate {

    func didSelectItemAtIndex(index: Int, sender: TopTabBarController) {
        print(index, sender)
    }

    func didSelectLeftButton(sender: TopTabBarController) {
        sender.dismiss(animated: true, completion: nil)
    }

    func didSelectRightButton(sender: TopTabBarController) {
        print("did select book mark")
    }
}

extension LearnContentItemCoordinator: LearnContentItemViewControllerDelegate {

    func didTapFinish(from view: UIView) {
        print("didTapFinish")
    }

    func didTapShare(in viewController: LearnContentItemViewController) {
        print("didTapShare")
    }

    func didChangeTab(to nextIndex: Index, in viewController: TopTabBarController) {
        print("didChangeTab")
    }

    func didSelectReadMoreContentCollection(with collectionID: Int, in viewController: LearnContentItemViewController) {        
        selectedContent = services.learnContentService.contentCollection(for: collectionID)
        relatedContents = services.learnContentService.contentCollections(for: selectedContent.relatedContentIDs)
        recommentedContentCollections = services.learnContentService.relatedContentCollections(for: category.remoteID)
        viewModel = LearnContentItemViewModel(
            contentCollection: selectedContent,
            relatedContentCollections: relatedContents,
            recommentedContentCollections: recommentedContentCollections
        )
        topTabBarControllerDelegate?.updateHeaderView(title: categoryTitle, subTitle: selectedContent.title)
        fullViewController.reloadData(viewModel: viewModel, contentTitle: selectedContent.title)
        bulletViewController.reloadData(viewModel: viewModel, contentTitle: selectedContent.title)
        audioViewController.reloadData(viewModel: viewModel, contentTitle: selectedContent.title)
    }

    func didTapVideo(with video: LearnContentItem, from view: UIView, in viewController: LearnContentItemViewController) {
        print("didTapVideo")
    }

    func didTapArticle(with article: LearnContentItem, from view: UIView, in viewController: LearnContentItemViewController) {
        print("didTapArticle")
    }
}
