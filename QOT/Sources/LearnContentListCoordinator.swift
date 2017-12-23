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

    private let services: Services
    private let eventTracker: EventTracker
    private let selectedCategoryIndex: Index
    private let learnContentListViewController: LearnContentListViewController
    private let rootViewController: UIViewController
    var children: [Coordinator] = []
    weak var delegate: LearnContentListCoordinatorDelegate?
    private let transitioningDelegate: UIViewControllerTransitioningDelegate // swiftlint:disable:this weak_delegate

    init(root: UIViewController,
         transitioningDelegate: UIViewControllerTransitioningDelegate,
         services: Services,
         eventTracker: EventTracker,
         selectedCategoryIndex: Index,
         originFrame: CGRect) {
        self.rootViewController = root
        self.transitioningDelegate = transitioningDelegate
        self.services = services
        self.eventTracker = eventTracker
        self.selectedCategoryIndex = selectedCategoryIndex
        let viewModel = LearnContentCollectionViewModel(services: services, selectedIndex: selectedCategoryIndex)
        learnContentListViewController = LearnContentListViewController(viewModel: viewModel, selectedCategoryIndex: self.selectedCategoryIndex)
        learnContentListViewController.modalPresentationStyle = .custom
        learnContentListViewController.transitioningDelegate = transitioningDelegate
        learnContentListViewController.delegate = self
    }

    func start() {
        rootViewController.present(learnContentListViewController, animated: true)
    }
}

extension LearnContentListCoordinator: LearnContentListViewControllerDelegate {

    func didSelectContent(_ content: ContentCollection, category: ContentCategory, originFrame: CGRect, in viewController: LearnContentListViewController) {
        let presentationManager = ContentItemAnimator(originFrame: originFrame)
        let coordinator = LearnContentItemCoordinator(root: viewController, eventTracker: eventTracker, services: services, content: content, category: category, presentationManager: presentationManager)
        startChild(child: coordinator)
    }

    func didTapBack(in viewController: LearnContentListViewController) {
        viewController.dismiss(animated: true)
        delegate?.removeChild(child: self)
    }
}
