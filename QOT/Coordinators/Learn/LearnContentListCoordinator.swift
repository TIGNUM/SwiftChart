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
    fileprivate let databaseManager: DatabaseManager
    fileprivate let eventTracker: EventTracker
    fileprivate let category: ContentCategory
    
    var children: [Coordinator] = []
    weak var delegate: LearnContentListCoordinatorDelegate?
    
    required init(root: LearnCategoryListViewController, databaseManager: DatabaseManager, eventTracker: EventTracker, category: ContentCategory) {
        self.rootVC = root
        self.databaseManager = databaseManager
        self.eventTracker = eventTracker
        self.category = category
    }
    
    func start() {
        let viewModel = LearnContentListViewModel(category: category)
        let vc = LearnContentListViewController(viewModel: viewModel)
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .custom
        vc.delegate =  self
        rootVC.present(vc, animated: true)
        
        eventTracker.track(page: vc.pageID, referer: rootVC.pageID, associatedEntity: category)
    }
}

extension LearnContentListCoordinator: LearnContentListViewControllerDelegate {
    func didSelectContent(at index: Index, in viewController: LearnContentListViewController) {
        log("Did select content at index: \(index)")
    }
    
    func didTapBack(in: LearnContentListViewController) {
        rootVC.dismiss(animated: true)
        delegate?.removeChild(child: self)
    }
}
