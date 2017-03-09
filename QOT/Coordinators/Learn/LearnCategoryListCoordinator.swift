//
//  LearnCategoryListCoordinator.swift
//  QOT
//
//  Created by Sam Wyndham on 09/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class LearnCategoryListCoordinator: ParentCoordinator {
    fileprivate let rootVC: RootViewController
    
    var children: [Coordinator] = []
    
    init(root: RootViewController) {
        self.rootVC = root
    }
    
    func start() {
        let viewModel = LearnCategoryListViewModel()
        let vc = LearnCategoryListViewController(viewModel: viewModel)
        vc.delegate =  self
        rootVC.present(vc, animated: false)
    }
}

extension LearnCategoryListCoordinator: LearnCategoryListViewControllerDelegate {
    func didSelectCategory(at index: Index, in viewController: LearnCategoryListViewController) {
        let coordinator = LearnContentListCoordinator(root: viewController)
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
