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
    fileprivate let eventTracker: EventTracker
    fileprivate let selectedCategoryIndex: Index
    fileprivate let learnContentListViewController: LearnContentListViewController
    fileprivate let rootViewController: UIViewController
    var children: [Coordinator] = []
    weak var delegate: LearnContentListCoordinatorDelegate?
    fileprivate let presentationManager: ZoomPresentationManager

    init(root: LearnCategoryListViewController, services: Services, eventTracker: EventTracker, selectedCategoryIndex: Index, originFrame: CGRect) {
        self.rootViewController = root
        self.services = services
        self.eventTracker = eventTracker
        self.selectedCategoryIndex = selectedCategoryIndex
        presentationManager = ZoomPresentationManager(openingFrame: originFrame)
        let viewModel = LearnContentCollectionViewModel(services: services, selectedIndex: selectedCategoryIndex)
        learnContentListViewController = LearnContentListViewController(viewModel: viewModel, selectedCategoryIndex: self.selectedCategoryIndex)
        learnContentListViewController.modalPresentationStyle = .custom
        learnContentListViewController.transitioningDelegate = presentationManager
        learnContentListViewController.delegate = self
    }
    
    func start() {
        rootViewController.present(learnContentListViewController, animated: true)
    }
}

extension LearnContentListCoordinator: LearnContentListViewControllerDelegate {

    func didSelectContent(_ content: ContentCollection, category: ContentCategory, originFrame: CGRect, in viewController: LearnContentListViewController) {
        let presentationManager = CircularPresentationManager(originFrame: originFrame)
        let coordinator = LearnContentItemCoordinator(root: viewController, eventTracker: eventTracker, services: services, content: content, category: category, presentationManager: presentationManager)
        startChild(child: coordinator)
    }
    
    func didTapBack(in viewController: LearnContentListViewController) {
        viewController.dismiss(animated: true)
        delegate?.removeChild(child: self)
    }
}
