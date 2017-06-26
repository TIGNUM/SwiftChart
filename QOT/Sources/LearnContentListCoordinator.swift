//
//  LearnContentListCoordinator.swift
//  QOT
//
//  Created by Sam Wyndham on 09/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

protocol LearnContentListCoordinatorDelegate: ParentCoordinator {}

final class LearnContentListCoordinator: ParentCoordinator {
    
    fileprivate let rootVC: LearnCategoryListViewController
    fileprivate let services: Services
    fileprivate let eventTracker: EventTracker
    fileprivate let category: ContentCategory
    fileprivate let selectedCategoryIndex: Index
    var children: [Coordinator] = []
    weak var delegate: LearnContentListCoordinatorDelegate?
    
    init(root: LearnCategoryListViewController, services: Services, eventTracker: EventTracker, category: ContentCategory, selectedCategoryIndex: Index) {
        self.rootVC = root
        self.services = services
        self.eventTracker = eventTracker
        self.category = category
        self.selectedCategoryIndex = selectedCategoryIndex
    }
    
    func start() {
        let viewModel = LearnContentCollectionViewModel(categories: services.contentService.learnContentCategories(), selectedIndex: selectedCategoryIndex)
        let contentListViewController = LearnContentListViewController(viewModel: viewModel, selectedCategoryIndex: self.selectedCategoryIndex)
        contentListViewController.modalTransitionStyle = .crossDissolve
        contentListViewController.modalPresentationStyle = .custom
        contentListViewController.delegate = self

        let topTabBarControllerItem = TopTabBarController.Item(
            controllers: [contentListViewController],
            themes: [.dark]
        )

        let topTabBarController = TopTabBarController(
            item: topTabBarControllerItem
        )
        
        topTabBarController.delegate = self
        rootVC.present(topTabBarController, animated: true)
        eventTracker.track(page: contentListViewController.pageID, referer: rootVC.pageID, associatedEntity: category)
    }
}

extension LearnContentListCoordinator: LearnContentListViewControllerDelegate {
    func didSelectContent(_ content: ContentCollection, category: ContentCategory, in viewController: LearnContentListViewController) {
        let coordinator = LearnContentItemCoordinator(root: viewController, services: services, eventTracker: eventTracker, content: content, category: category)
        startChild(child: coordinator)
    }
    
    func didTapBack(in viewController: LearnContentListViewController) {
        viewController.dismiss(animated: true)
        delegate?.removeChild(child: self)
    }
}

// MARK: - TopTabBarDelegate

extension LearnContentListCoordinator: TopTabBarDelegate {

    func didSelectRightButton(sender: TopTabBarController) {
        sender.dismiss(animated: true, completion: nil)
    }

    func didSelectLeftButton(sender: TopTabBarController) {
        print("Search button pressed", sender)
    }

    func didSelectItemAtIndex(index: Int, sender: TopTabBarController) {
        print("didSelectItemAtIndex", index as Any, sender)
    }
}
