//
//  TabBarCoordinator.swift
//  QOT
//
//  Created by karmic on 22/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

final class TabBarCoordinator: ParentCoordinator {
    
    // MARK: - Properties
    
    fileprivate let rootViewController: MainMenuViewController
    fileprivate let databaseManager: DatabaseManager
    fileprivate let eventTracker: EventTracker
    fileprivate let selectedIndex: Index
    
    fileprivate lazy var categories: Results<ContentCategory> = {
        return self.databaseManager.mainRealm.objects(ContentCategory.self).sorted(byKeyPath: "sort")
    }()
    
    fileprivate lazy var learnCategoryListViewController: LearnCategoryListViewController = {
        let viewModel = LearnCategoryListViewModel(categories: self.categories)
        let learnCategoryListVC = LearnCategoryListViewController(viewModel: viewModel)
        return learnCategoryListVC
    }()
    
    
    
    var children = [Coordinator]()
    var viewControllers = [UIViewController]()
    
    // MARK: - Life Cycle
    
    required init(rootViewController: MainMenuViewController, selectedIndex: Index, databaseManager: DatabaseManager, eventTracker: EventTracker) {
        self.rootViewController = rootViewController
        self.databaseManager = databaseManager
        self.eventTracker = eventTracker
        self.selectedIndex = selectedIndex
        self.addViewControllers()
    }
    
    func start() {
        let tabBarController = TabBarController(viewControllers: viewControllers, selectedIndex: selectedIndex)
        tabBarController.modalTransitionStyle = .crossDissolve
        tabBarController.modalPresentationStyle = .custom
        rootViewController.present(tabBarController, animated: true)
    }
    
    func addChildren(tabBarController: TabBarController) {
        let learnCategoryListCoordinator = LearnCategoryListCoordinator(root: tabBarController, databaseManager: databaseManager, eventTracker: eventTracker)
        children.append(learnCategoryListCoordinator)
    }
    
    func addViewControllers() {
        viewControllers.append(learnCategoryListViewController)
        viewControllers.append(learnCategoryListViewController)
        viewControllers.append(learnCategoryListViewController)
    }
}
