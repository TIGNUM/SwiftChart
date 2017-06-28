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

    fileprivate let window: UIWindow
    fileprivate let services: Services
    fileprivate let eventTracker: EventTracker
    fileprivate let selectedIndex: Index
    fileprivate var viewControllers = [UIViewController]()
    fileprivate var tabBarController: TabBarController?
    fileprivate let prepareChatDecisionManager: PrepareChatDecisionManager

    var children = [Coordinator]()

    fileprivate lazy var prepareChatViewController: ChatViewController<Answer> = {
        let viewModel = ChatViewModel<Answer>()
        let viewController = ChatViewController(viewModel: viewModel)

        viewController.didSelectChoice = { [weak self] (choice, viewController) in
            self?.prepareChatDecisionManager.didSelectChoice(choice)
        }
        return viewController
    }()

    fileprivate lazy var topTabBarControllerLearn: TopTabBarController = {
        let categories = self.services.contentService.learnContentCategories()
        let articleCategories = self.services.articleService.categories()
        let articlesCollections = self.services.articleService.contentCollections(for: articleCategories)
        let viewModel = LearnCategoryListViewModel(categories: categories, realmObserver: RealmObserver(realm: self.services.mainRealm))
        let learnCategoryListVC = LearnCategoryListViewController(viewModel: viewModel)
        let articleCollectionViewModel = ArticleCollectionViewModel(categories: articleCategories, contentCollections: articlesCollections)
        let articleCollectionViewController = ArticleCollectionViewController(viewModel: articleCollectionViewModel)

        let topBarControllerItem = TopTabBarController.Item(
            controllers: [learnCategoryListVC, articleCollectionViewController],
            themes: [.darkClear, .dark],
            titles: [
                R.string.localized.topTabBarItemTitleLearnStrategies(),
                R.string.localized.topTabBarItemTitleLearnWhatsHot()
            ],
            enableTabScrolling: false
        )

        let topTabBarController = TopTabBarController(
            item: topBarControllerItem,
            leftIcon: R.image.ic_search(),
            rightIcon: R.image.ic_menu()
        )

        articleCollectionViewController.delegate = self
        topTabBarController.delegate = self
        learnCategoryListVC.delegate = self

        return topTabBarController
    }()

    fileprivate lazy var topTabBarControllerMe: TopTabBarController = {
        let myUniverseViewController = MyUniverseViewController(
            myDataViewModel: MyDataViewModel(),
            myWhyViewModel: MyWhyViewModel()
        )

        let topBarControllerItem = TopTabBarController.Item(
            controllers: [myUniverseViewController],
            themes: [.darkClear],
            titles: [
                R.string.localized.topTabBarItemTitleMeMyData(),
                R.string.localized.topTabBarItemTitleMeMyWhy()
            ],
            containsScrollView: true,
            contentView: myUniverseViewController.contentView
        )

        let topTabBarController = TopTabBarController(
            item: topBarControllerItem,
            rightIcon: R.image.ic_menu()
        )

        topTabBarController.delegate = self        
        myUniverseViewController.delegate = self
        myUniverseViewController.contentScrollViewDelegate = topTabBarController

        let contentScrollView = myUniverseViewController.scrollView()
        myUniverseViewController.addSubViews(contentScrollView: contentScrollView)
        topTabBarController.scrollView = contentScrollView

        return topTabBarController
    }()

    fileprivate lazy var topTabBarControllerPrepare: TopTabBarController = {
        let chatViewController = self.prepareChatViewController
        let myPrepViewModel = MyPrepViewModel()
        let myPrepViewController = MyPrepViewController(viewModel: myPrepViewModel)

        let topBarControllerItem = TopTabBarController.Item(
            controllers: [chatViewController, myPrepViewController],
            themes: [.dark, .dark],
            titles: [
                R.string.localized.topTabBarItemTitlePerpareCoach(),
                R.string.localized.topTabBarItemTitlePerparePrep()
            ]
        )
        
        let topTabBarController = TopTabBarController(
            item: topBarControllerItem,
            leftIcon: R.image.ic_search(),
            rightIcon: R.image.ic_menu()
        )

        topTabBarController.delegate = self
        
        return topTabBarController
    }()
    
    // MARK: - Init
    
    init(window: UIWindow, selectedIndex: Index, services: Services, eventTracker: EventTracker) {
        self.window = window
        self.services = services
        self.eventTracker = eventTracker
        self.selectedIndex = selectedIndex
        self.prepareChatDecisionManager = PrepareChatDecisionManager(service: services.questionsService)

        prepareChatDecisionManager.delegate = self
    }
}

// MARK: - TopTabBarControllers

private extension TabBarCoordinator {
    
    func bottomTabBarController() -> TabBarController {
        addViewControllers()
        let bottomTabBarController = TabBarController(items: tabBarControllerItems(), selectedIndex: 0)
        bottomTabBarController.modalTransitionStyle = .crossDissolve
        bottomTabBarController.modalPresentationStyle = .custom
        bottomTabBarController.delegate = self

        return bottomTabBarController
    }

    func tabBarControllerItems() -> [TabBarController.Item] {
        return [
            TabBarController.Item(controller: topTabBarControllerLearn, title: R.string.localized.tabBarItemLearn()),
            TabBarController.Item(controller: topTabBarControllerMe, title: R.string.localized.tabBarItemMe()),
            TabBarController.Item(controller: topTabBarControllerPrepare, title: R.string.localized.tabBarItemPrepare())
        ]
    }
}

// MARK: - Helpers

extension TabBarCoordinator {

    func start() {
        let bottomTabBarController = self.bottomTabBarController()
        window.rootViewController = bottomTabBarController
        window.makeKeyAndVisible()
        eventTracker.track(page: bottomTabBarController.pageID, referer: bottomTabBarController.pageID, associatedEntity: nil)
        tabBarController = bottomTabBarController
    }

    func addViewControllers() {
        viewControllers.append(topTabBarControllerLearn)
        viewControllers.append(topTabBarControllerMe)
        viewControllers.append(topTabBarControllerPrepare)
    }
}

// MARK: - TabBarControllerDelegate

extension TabBarCoordinator: TabBarControllerDelegate {

    func didSelectTab(at index: Index, in controller: TabBarController) {
        switch index {
        case 2:
            prepareChatDecisionManager.start()
        default:
            break
        }
    }
}

// MARK: - LearnCategoryListViewControllerDelegate

extension TabBarCoordinator: LearnCategoryListViewControllerDelegate {

    func didSelectCategory(at index: Index, category: ContentCategory, in viewController: LearnCategoryListViewController) {
        let coordinator = LearnContentListCoordinator(root: viewController, services: services, eventTracker: eventTracker, category: category, selectedCategoryIndex: index)
        coordinator.delegate = self
        startChild(child: coordinator)
    }
}

// MARK: - LearnContentListCoordinatorDelegate

extension TabBarCoordinator: LearnContentListCoordinatorDelegate {

    func didFinish(coordinator: LearnContentListCoordinator) {
        if let index = children.index(where: { $0 === coordinator}) {
            children.remove(at: index)
        }
    }
}

// MARK: - MeSectionDelegate

extension TabBarCoordinator: MyUniverseViewControllerDelegate {

    func didTapSector(sector: Sector?, in viewController: MyUniverseViewController) {
        let coordinator = MyStatisticsCoordinator(root: topTabBarControllerMe, services: services, eventTracker: eventTracker)
        startChild(child: coordinator)
    }

    func didTapMyToBeVision(vision: Vision?, from view: UIView, in viewController: MyUniverseViewController) {
        let coordinator = MyToBeVisionCoordinator(root: topTabBarControllerMe, services: services, eventTracker: eventTracker)
        startChild(child: coordinator)
    }

    func didTapWeeklyChoices(weeklyChoice: WeeklyChoice?, from view: UIView, in viewController: MyUniverseViewController) {
        let coordinator = WeeklyChoicesCoordinator(root: topTabBarControllerMe, services: services, eventTracker: eventTracker)
        startChild(child: coordinator)
    }

    func didTapQOTPartner(selectedIndex: Index, partners: [Partner], from view: UIView, in viewController: MyUniverseViewController) {
        let coordinator = PartnersCoordinator(root: topTabBarControllerMe, services: services, eventTracker: eventTracker, partners: partners, selectedIndex: selectedIndex)
        startChild(child: coordinator)
    }
}

// MARK: - ArticleCollectionViewControllerDelegate

extension TabBarCoordinator: ArticleCollectionViewControllerDelegate {

    func didTapItem(articleHeader: ArticleCollectionHeader, in viewController: ArticleCollectionViewController) {
        guard articleHeader.articleContentCollection.articleItems.count > 0 else {
            viewController.showAlert(type: .noContent, handler: nil, handlerDestructive: nil)
            return
        }

        let coordinator = ArticleContentItemCoordinator(
            root: viewController,
            services: services,
            eventTracker: eventTracker,
            articleHeader: articleHeader
        )

        coordinator.startChild(child: coordinator)
    }
}

// MARK: - TopTabBarDelegate

extension TabBarCoordinator: TopTabBarDelegate {

    func didSelectLeftButton(sender: TopTabBarController) {
        print("didSelectLeftButton", sender)
    }

    func didSelectRightButton(sender: TopTabBarController) {
        print("didSelectRightButton", sender)
        guard let tabBarController = tabBarController else {
            return
        }

        let coordinator = SidebarCoordinator(root: tabBarController, services: services, eventTracker: eventTracker)
        startChild(child: coordinator)
    }

    func didSelectItemAtIndex(index: Int, sender: TopTabBarController) {
        print("didSelectItemAtIndex", index, sender)
    }
}

// MARK: PrepareChatDecisionManagerDelegate

extension TabBarCoordinator: PrepareChatDecisionManagerDelegate {

    func setItems(_ items: [ChatItem<Answer>], manager: PrepareChatDecisionManager) {
        prepareChatViewController.viewModel.setItems(items: items)
    }

    func appendItems(_ items: [ChatItem<Answer>], manager: PrepareChatDecisionManager) {
        prepareChatViewController.viewModel.append(items: items)
    }

    func showContent(id: Int, manager: PrepareChatDecisionManager) {
        guard let tabViewController = tabBarController else {
            return
        }
        
        let coordinator = PrepareContentCoordinator(root: tabViewController, services: services, eventTracker: eventTracker)
        coordinator.delagate = self
        startChild(child: coordinator)
    }
}

extension TabBarCoordinator: PrepareContentCoordinatorDelegate {
    func prepareContentDidFinish(coordinator: PrepareContentCoordinator) {
        removeChild(child: coordinator)
        prepareChatDecisionManager.repeatFlow()
    }
}
