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
    
    init(rootViewController: MainMenuViewController, selectedIndex: Index, databaseManager: DatabaseManager, eventTracker: EventTracker) {
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
    func didSelectChatInput(_ input: ChatMessageInput, in viewController: ChatViewController) {
        log("didSelectChatInput: \(input)")
    }
    
    func didSelectChatNavigation(_ chatMessageNavigation: ChatMessageNavigation, in viewController: ChatViewController) {
        let viewModel = PrepareContentViewModel()
        let prepareContentViewController = PrepareContentViewController(viewModel: viewModel)
        prepareContentViewController.delegate = self
        viewController.present(prepareContentViewController, animated: true, completion: nil)
    }
}

// MARK: - PrepareContentViewControllerDelegate

extension TabBarCoordinator: PrepareContentViewControllerDelegate {
    func didTapClose(in viewController: PrepareContentViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }

    func didTapShare(in viewController: PrepareContentViewController) {
        log("didTapShare")
    }

    func didTapVideo(with ID: String, from view: UIView, in viewController: PrepareContentViewController) {
        log("didTapVideo: ID: \(ID)")
    }

    func didTapAddPreparation(in viewController: PrepareContentViewController) {
        log("didTapAddPreparation")
    }

    func didTapAddToNotes(in viewController: PrepareContentViewController) {
        log("didTapAddToNotes")
    }

    func didTapSaveAs(in viewController: PrepareContentViewController) {
        log("didTapSaveAs")
    }

    func didTapAddPreparationInCollection(with ID: String, in viewController: PrepareContentViewController) {
        log("didTapAddPreparationInCollection")
    }

    func didTapAddToNotes(with ID: String, in viewController: PrepareContentViewController) {
        log("didTapAddToNotes")
    }

    func didTapSaveAs(with ID: String, in viewController: PrepareContentViewController) {
        log("didTapSaveAs: ID: \(ID)")
    }
}

// MARK: - PrepareCheckListViewControllerDelegate

extension TabBarCoordinator: PrepareCheckListViewControllerDelegate {
    func didTapClose(in viewController: PrepareCheckListViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }

    func didTapVideo(with ID: String, from view: UIView, in viewController: PrepareCheckListViewController) {
        log("didTapVideo: ID: \(ID) view: \(view)")
    }

    func didTapSelectCheckbox(with ID: String, from view: UIView, at index: Index, in viewController: PrepareCheckListViewController) {
        log("didTapSelectCheckbox: ID: \(ID), index: \(index), view: \(view)")
    }

    func didTapDeselectCheckbox(with ID: String, from view: UIView, at index: Index, in viewController: PrepareCheckListViewController) {
        log("didTapDeselectCheckbox: ID: \(ID), index: \(index), view: \(view)")
    }
}

// MARK: - LearnStrategyViewControllerDelegate

extension TabBarCoordinator: LearnStrategyViewControllerDelegate {
    func didTapClose(in viewController: LearnStrategyViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }

    func didTapShare(in viewController: LearnStrategyViewController) {
        log("didTapShare")
    }

    func didTapVideo(with video: LearnStrategyItem, from view: UIView, in viewController: LearnStrategyViewController) {
        switch video {
        case .video(let localID, let placeholderURL, let description):
            log("didTapVideo: localID: \(localID), placeholderURL: \(placeholderURL), description: \(description) in view: \(view)")
        default: log("didTapArticle NO ARTICLE!")
        }
    }

    func didTapArticle(with article: LearnStrategyItem, from view: UIView, in viewController: LearnStrategyViewController) {
        switch article {
        case .article(let localID, let title, let subtitle): log("didTapArticle: localID: \(localID), title: \(title), subtitle: \(subtitle) in view: \(view)")
        default: log("didTapArticle NO ARTICLE!")
        }
    }
}

// MARK: - WhatsHotViewControllerDelegate

extension TabBarCoordinator: WhatsHotViewControllerDelegate {
    func didTapVideo(at index: Index, with whatsHot: WhatsHotItem, from view: UIView, in viewController: WhatsHotViewController) {
        log("didTapVideo: index: \(index), whatsHotItem.URL: \(whatsHot.placeholderURL.absoluteString)")
    }

    func didTapBookmark(at index: Index, with whatsHot: WhatsHotItem, in view: UIView, in viewController: WhatsHotViewController) {
        log("didTapBookmark: index: \(index), whatsHotItem.bookmarked: \(whatsHot.bookmarked)")
    }
}
