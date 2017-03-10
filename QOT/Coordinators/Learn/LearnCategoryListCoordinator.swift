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
    fileprivate let rootVC: UIViewController
    fileprivate let databaseManager: DatabaseManager
    fileprivate lazy var categories: Results<ContentCategory> = {
        return self.databaseManager.mainRealm.objects(ContentCategory.self).sorted(byKeyPath: "sort")
    }()
    
    var children: [Coordinator] = []
    
    init(root: UIViewController, databaseManager: DatabaseManager) {
        self.rootVC = root
        self.databaseManager = databaseManager
    }
    
    func start() {
        let viewModel = LearnCategoryListViewModel(categories: categories)
        let vc = LearnCategoryListViewController(viewModel: viewModel)
        vc.delegate =  self
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .custom
        rootVC.present(vc, animated: true)
    }
}

extension LearnCategoryListCoordinator: LearnCategoryListViewControllerDelegate {
    func didSelectCategory(at index: Index, in viewController: LearnCategoryListViewController) {
        let category = categories[index]
        let coordinator = LearnContentListCoordinator(root: viewController, databaseManager: databaseManager, category: category)
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
