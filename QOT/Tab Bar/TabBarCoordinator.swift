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
    
    fileprivate lazy var contentCategories: Results<ContentCategory> = {
        return self.databaseManager.mainRealm.objects(ContentCategory.self).sorted(byKeyPath: Databsase.Key.sort.rawValue)
    }()
    
    fileprivate lazy var learnCategoryListViewController: LearnCategoryListViewController = {
        let viewModel = LearnCategoryListViewModel(categories: self.contentCategories)
        let learnCategoryListVC = LearnCategoryListViewController(viewModel: viewModel)
        learnCategoryListVC.delegate = self
        return learnCategoryListVC
    }()
    
    fileprivate lazy var meSectionViewController: MeSectionViewController = {
        let meViewController = MeSectionViewController()
        meViewController.delegate = self
        
        return meViewController
    }()
    
    fileprivate lazy var chatViewController: ChatViewController = {
        let viewModel = ChatViewModel()
        let chatViewController = ChatViewController(viewModel: viewModel)
        chatViewController.delegate = self

        return chatViewController
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
    
    func addViewControllers() {
        viewControllers.append(learnCategoryListViewController)
        viewControllers.append(meSectionViewController)
        viewControllers.append(chatViewController)
    }
}

// MARK: - LearnCategoryListViewControllerDelegate

extension TabBarCoordinator: LearnCategoryListViewControllerDelegate {
    func didSelectCategory(at index: Index, in viewController: LearnCategoryListViewController) {
        let category = contentCategories[index]
        let coordinator = LearnContentListCoordinator(root: viewController, databaseManager: databaseManager, eventTracker: eventTracker, category: category)
        coordinator.start()
        coordinator.delegate = self
        
        children.append(coordinator)
    }
}

extension TabBarCoordinator: LearnContentListCoordinatorDelegate {
    func didFinish(coordinator: LearnContentListCoordinator) {
        if let index = children.index(where: { $0 === coordinator}) {
            children.remove(at: index)
        }
    }
}

// MARK: - MeSectionDelegate

extension TabBarCoordinator: MeSectionDelegate {
    
    func didTapMeSectionItem(in viewController: MeSectionViewController) {
        // TODO
    }
}

// MARK: - PrepareChatBotDelegate

extension TabBarCoordinator: ChatViewDelegate {
    
    func didSelectChatSectionNavigate(in viewController: ChatViewController, chatSection: ChatSection) {
        QOTLog(true, "didSelectChatSectionNavigate with chatSection: \(chatSection)")
    }

    func didSelectChatSectionUpdate(in viewController: ChatViewController, chatSection: ChatSection) {
        QOTLog(true, "didSelectChatSectionUpdate with chatSection: \(chatSection)")
    }
}
