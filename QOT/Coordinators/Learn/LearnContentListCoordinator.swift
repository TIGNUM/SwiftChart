//
//  LearnContentListCoordinator.swift
//  QOT
//
//  Created by Sam Wyndham on 09/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

protocol LearnContentListCoordinatorDelegate: class {
    func didFinish(coordinator: LearnContentListCoordinator)
}

final class LearnContentListCoordinator: ParentCoordinator {
    fileprivate let rootVC: UIViewController
    fileprivate let databaseManager: DatabaseManager
    fileprivate let category: ContentCategory
    
    var children: [Coordinator] = []
    weak var delegate: LearnContentListCoordinatorDelegate?
    
    init(root: UIViewController, databaseManager: DatabaseManager, category: ContentCategory) {
        self.rootVC = root
        self.databaseManager = databaseManager
        self.category = category
    }
    
    func start() {
        let viewModel = LearnContentListViewModel(category: category)
        let vc = LearnContentListViewController(viewModel: viewModel)
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .custom
        vc.delegate =  self
        rootVC.present(vc, animated: true)
    }
}

extension LearnContentListCoordinator: LearnContentListViewControllerDelegate {
    func didSelectContent(at index: Index, in viewController: LearnContentListViewController) {
        print("Did selcect content at index: \(index)")
    }
    
    func didTapBack(in: LearnContentListViewController) {
        rootVC.dismiss(animated: true)
    }
}
