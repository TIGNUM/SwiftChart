//
//  LearnContentItemCoordinator.swift
//  QOT
//
//  Created by tignum on 3/30/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import RealmSwift

final class LearnContentItemCoordinator: ParentCoordinator {
    
    fileprivate let rootVC: UIViewController
    fileprivate let services: Services
    fileprivate let category: ContentCategory
    fileprivate var categoryTitle: String
    fileprivate var selectedContent: ContentCollection
    fileprivate var fullViewController: LearnContentItemViewController
    fileprivate var bulletViewController: LearnContentItemViewController
    fileprivate var audioViewController: LearnContentItemViewController
    fileprivate var viewModel: LearnContentItemViewModel
    weak var topTabBarControllerDelegate: TopTabBarControllerDelegate?
    var children: [Coordinator] = []
    
    init(root: UIViewController, services: Services, content: ContentCollection, category: ContentCategory) {
        self.rootVC = root
        self.services = services
        self.category = category
        self.categoryTitle = category.title.capitalized
        self.selectedContent = content
        self.viewModel = LearnContentItemViewModel(
            services: services,
            contentCollection: selectedContent,
            categoryID: category.remoteID
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

        fullViewController.delegate = self
        bulletViewController.delegate = self
        audioViewController.delegate = self

        topTabBarController.modalTransitionStyle = .crossDissolve
        if rootVC is UIViewControllerTransitioningDelegate {
            topTabBarController.modalPresentationStyle = .fullScreen  // Custom animations doesn't work when this value is set to .custom

            // If rootVC has a custom defined transition that one will be used
            // We have a custom transition from PrepareContent (when pressing readMore button)
            guard let transitionDelegate = rootVC as? UIViewControllerTransitioningDelegate else { return }
            topTabBarController.transitioningDelegate = transitionDelegate
        } else {
            topTabBarController.modalPresentationStyle = .custom
        }

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
        guard let contentCollection = services.contentService.contentCollection(id: collectionID) else {
            return
        }

        selectedContent = contentCollection
        viewModel = LearnContentItemViewModel(
            services: services,
            contentCollection: selectedContent,
            categoryID: category.remoteID
        )
        topTabBarControllerDelegate?.updateHeaderView(title: categoryTitle, subTitle: selectedContent.title)
        fullViewController.reloadData(viewModel: viewModel)
        bulletViewController.reloadData(viewModel: viewModel)
        audioViewController.reloadData(viewModel: viewModel)
    }

    func didTapVideo(with video: ContentItem, from view: UIView, in viewController: LearnContentItemViewController) {
        print("didTapVideo")
    }

    func didTapArticle(with article: ContentItem, from view: UIView, in viewController: LearnContentItemViewController) {
        print("didTapArticle")
    }
}
