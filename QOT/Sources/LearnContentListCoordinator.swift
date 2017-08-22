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

    fileprivate let services: Services
    fileprivate let selectedCategoryIndex: Index
    fileprivate let learnContentListViewController: LearnContentListViewController
    fileprivate var topTabBarController: UINavigationController!
    fileprivate let rootViewController: UIViewController
    var children: [Coordinator] = []
    weak var delegate: LearnContentListCoordinatorDelegate?
    fileprivate let presentationManager: ZoomPresentationManager

    init(root: LearnCategoryListViewController, services: Services, selectedCategoryIndex: Index, originFrame: CGRect) {
        self.rootViewController = root
        self.services = services
        self.selectedCategoryIndex = selectedCategoryIndex
        presentationManager = ZoomPresentationManager(openingFrame: originFrame)
        let viewModel = LearnContentCollectionViewModel(services: services, selectedIndex: selectedCategoryIndex)
        learnContentListViewController = LearnContentListViewController(viewModel: viewModel, selectedCategoryIndex: self.selectedCategoryIndex)
        topTabBarController = UINavigationController(withPages: [learnContentListViewController], topBarDelegate: self)
        topTabBarController.modalPresentationStyle = .custom
        topTabBarController.transitioningDelegate = presentationManager
        learnContentListViewController.delegate = self
    }
    
    func start() {
        rootViewController.present(topTabBarController, animated: true)
    }
}

extension LearnContentListCoordinator: LearnContentListViewControllerDelegate {

    func didSelectContent(_ content: ContentCollection, category: ContentCategory, originFrame: CGRect, in viewController: LearnContentListViewController) {
        let presentationManager = CircularPresentationManager(originFrame: originFrame)
        let coordinator = LearnContentItemCoordinator(root: viewController, services: services, content: content, category: category, presentationManager: presentationManager)
        startChild(child: coordinator)
    }
    
    func didTapBack(in viewController: LearnContentListViewController) {
        viewController.dismiss(animated: true)
        delegate?.removeChild(child: self)
    }
}

// MARK: - TopNavigationBarDelegate

extension LearnContentListCoordinator: TopNavigationBarDelegate {

    func topNavigationBar(_ navigationBar: TopNavigationBar, leftButtonPressed button: UIBarButtonItem) {
    }
    
    func topNavigationBar(_ navigationBar: TopNavigationBar, middleButtonPressed button: UIButton, withIndex index: Int, ofTotal total: Int) {
    }
    
    func topNavigationBar(_ navigationBar: TopNavigationBar, rightButtonPressed button: UIBarButtonItem) {
        topTabBarController.dismiss(animated: true, completion: nil)
    }
}
