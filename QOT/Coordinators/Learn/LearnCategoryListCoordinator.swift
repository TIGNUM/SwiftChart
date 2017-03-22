//
//  LearnCategoryListCoordinator.swift
//  QOT
//
//  Created by Sam Wyndham on 09/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import RealmSwift

final class LearnCategoryListCoordinator: ParentCoordinator {
    fileprivate let rootVC: TabBarController
    fileprivate let databaseManager: DatabaseManager
    fileprivate let eventTracker: EventTracker
    fileprivate lazy var categories: Results<ContentCategory> = {
        return self.databaseManager.mainRealm.objects(ContentCategory.self).sorted(byKeyPath: "sort")
    }()
    
    var children: [Coordinator] = []
    
    required init(root: TabBarController, databaseManager: DatabaseManager, eventTracker: EventTracker) {
        self.rootVC = root
        self.databaseManager = databaseManager
        self.eventTracker = eventTracker
    }
    
    func start() {
        let viewModel = LearnCategoryListViewModel(categories: categories)
        let learnCategoryListViewController = LearnCategoryListViewController(viewModel: viewModel)
        learnCategoryListViewController.delegate =  self
        learnCategoryListViewController.modalTransitionStyle = .crossDissolve
        learnCategoryListViewController.modalPresentationStyle = .custom
        rootVC.present(learnCategoryListViewController, animated: true)
        
//        eventTracker.track(page: vc.pageID, referer: rootVC.pageID, associatedEntity: nil)
    }
}

extension LearnCategoryListCoordinator: LearnCategoryListViewControllerDelegate {
    func didSelectCategory(at index: Index, in viewController: LearnCategoryListViewController) {
        let category = categories[index]
        let coordinator = LearnContentListCoordinator(root: viewController, databaseManager: databaseManager, eventTracker: eventTracker, category: category)
        coordinator.start()
        coordinator.delegate = self
        
        children.append(coordinator)
    }
}

extension LearnCategoryListCoordinator: LearnContentListCoordinatorDelegate {
    func didFinish(coordinator: LearnContentListCoordinator) {
        if let index = children.index(where: { $0 === coordinator}) {
            children.remove(at: index)
        }
    }
}
