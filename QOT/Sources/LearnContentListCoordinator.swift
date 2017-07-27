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
    fileprivate let selectedCategoryIndex: Index
    var children: [Coordinator] = []
    weak var delegate: LearnContentListCoordinatorDelegate?

    fileprivate let presentationManager: ZoomPresentationManager

    init(root: LearnCategoryListViewController, services: Services, selectedCategoryIndex: Index, originFrame: CGRect) {
        self.rootVC = root
        self.services = services
        self.selectedCategoryIndex = selectedCategoryIndex
        self.presentationManager = ZoomPresentationManager(openingFrame: originFrame)
    }
    
    func start() {
        let viewModel = LearnContentCollectionViewModel(services: services, selectedIndex: selectedCategoryIndex)
        let contentListViewController = LearnContentListViewController(viewModel: viewModel, selectedCategoryIndex: self.selectedCategoryIndex)

        let topTabBarControllerItem = TopTabBarController.Item(
            controllers: [contentListViewController],
            themes: [.dark]
        )

        let topTabBarController = TopTabBarController(
            item: topTabBarControllerItem
        )

        contentListViewController.delegate = self
        topTabBarController.delegate = self
        topTabBarController.modalPresentationStyle = .custom

        topTabBarController.transitioningDelegate = presentationManager

        rootVC.present(topTabBarController, animated: true)
    }
}

extension LearnContentListCoordinator: LearnContentListViewControllerDelegate {
    func didSelectContent(_ content: ContentCollection, category: ContentCategory, in viewController: LearnContentListViewController) {
        let coordinator = LearnContentItemCoordinator(root: viewController, services: services, content: content, category: category)
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
