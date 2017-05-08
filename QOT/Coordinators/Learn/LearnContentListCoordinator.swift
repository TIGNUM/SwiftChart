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
    fileprivate let category: LearnContentCategory
    
    var children: [Coordinator] = []
    weak var delegate: LearnContentListCoordinatorDelegate?
    
    init(root: LearnCategoryListViewController, services: Services, eventTracker: EventTracker, category: LearnContentCategory) {
        self.rootVC = root
        self.services = services
        self.eventTracker = eventTracker
        self.category = category
    }
    
    func start() {
        let viewModel = LearnContentCollectionViewModel(category: category)
        let vc = LearnContentListViewController(viewModel: viewModel)
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .custom
        vc.delegate =  self

        let topTabBarControllerItem = TopTabBarController.Item(
            controllers: [vc],
            titles: [R.string.localized.learnCategoryListViewTitle()]
        )

        let topTabBarController = TopTabBarController(
            item: topTabBarControllerItem,
            leftIcon: R.image.ic_search(),
            rightIcon: R.image.ic_close()
        )

        topTabBarController.delegate = self
        rootVC.present(topTabBarController, animated: true)
        eventTracker.track(page: vc.pageID, referer: rootVC.pageID, associatedEntity: category)
    }
}

extension LearnContentListCoordinator: LearnContentListViewControllerDelegate {
    func didSelectContent(at index: Index, in viewController: LearnContentListViewController) {
        let coordinator = LearnContentItemCoordinator(
            root: viewController,
            services: services,
            eventTracker: eventTracker,
            category: category,
            at: index
        )
        startChild(child: coordinator)
    }
    
    func didTapBack(in: LearnContentListViewController) {
        rootVC.dismiss(animated: true)
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

    func didSelectItemAtIndex(index: Int?, sender: TopTabBarController) {
        print("didSelectItemAtIndex", index, sender)
    }
}
