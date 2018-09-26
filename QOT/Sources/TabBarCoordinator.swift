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
import Bond
import ReactiveKit

final class TabBarCoordinator: NSObject, ParentCoordinator {

    // MARK: - Properties

    var children = [Coordinator]()
    private let windowManager: WindowManager
    private let services: Services
    private let eventTracker: EventTracker
    private let selectedIndex: Observable<Index>
    private let permissionsManager: PermissionsManager
    private let pageTracker: PageTracker
    private let networkManager: NetworkManager
    private let syncManager: SyncManager
    private let articleCollectionProvider: ArticleCollectionProvider
    private let tokenBin = TokenBin()
    private let badgeManager: BadgeManager

    private lazy var myUniverseProvider = MyUniverseProvider(services: services)

    lazy var prepareCoordinator: PrepareCoordinator = {
        return PrepareCoordinator(services: self.services,
                                  eventTracker: self.eventTracker,
                                  permissionsManager: self.permissionsManager,
                                  tabBarController: self.tabBarController,
                                  topTabBarController: self.topTabBarControllerPrepare,
                                  chatViewController: self.prepareChatViewController,
                                  myPrepViewController: self.myPrepViewController)
    }()

    lazy var prepareChatViewController: ChatViewController<PrepareAnswer> = {
        let viewModel = ChatViewModel<PrepareAnswer>(items: [])
        let viewController = ChatViewController(pageName: .prepareChat,
                                                viewModel: viewModel,
                                                fadeMaskLocation: .topAndBottom)
        viewController.title = R.string.localized.topTabBarItemTitlePerpareCoach()
        return viewController
    }()

    private lazy var myPrepViewController: MyPrepViewController = {
        let viewModel = MyPrepViewModel(services: self.services)
        let viewController = MyPrepViewController(viewModel: viewModel, syncManager: syncManager)
        viewController.title = R.string.localized.topTabBarItemTitlePerparePrep()
        return viewController
    }()

    // MARK: - tab bar

    private lazy var tabBarController: TabBarController = {
        let controller = TabBarController(config: .default)
        controller.modalTransitionStyle = .crossDissolve
        controller.modalPresentationStyle = .custom
        controller.tabBarControllerDelegate = self
        controller.selectedIndex = selectedIndex.value
        controller.viewControllers = [topTabBarControllerGuide,
                                      topTabBarControllerLearn,
                                      topTabBarControllerMe,
                                      topTabBarControllerPrepare]
        badgeManager.guideBadgeContainer = (view: controller.tabBar.subviews[TabBar.guide.index],
                                            frame: controller.frameForButton(at: TabBar.guide.index) ?? .zero)
        badgeManager.learnBadgeContainer = (view: controller.tabBar.subviews[TabBar.learn.index],
                                            frame: controller.frameForButton(at: TabBar.learn.index) ?? .zero)
        return controller
    }()

    private lazy var articleCollectionViewController: ArticleCollectionViewController = {
        let viewController = ArticleCollectionViewController(pageName: .whatsHot,
                                                             viewData: articleCollectionProvider.provideViewData(),
                                                             fadeMaskLocation: .topAndBottom)
        viewController.title = R.string.localized.topTabBarItemTitleLearnWhatsHot()
        viewController.delegate = self
        return viewController
    }()

    lazy var topTabBarControllerGuide: UINavigationController = {
        let guideViewController = GuideViewController(configurator: GuideConfigurator.make(badgeManager: badgeManager))
        guideViewController.title = R.string.localized.topTabBarItemTitleGuide()
        let leftButton = UIBarButtonItem(withImage: R.image.ic_menu())
        let topTabBarController = UINavigationController(withPages: [guideViewController],
                                                         topBarDelegate: self,
                                                         leftButton: leftButton,
                                                         rightButton: .info)
        topTabBarController.tabBarItem = TabBarItem(config: TabBar.guide.itemConfig)
        return topTabBarController
    }()

    private lazy var topTabBarControllerLearn: UINavigationController = {
        let viewModel = LearnCategoryListViewModel(services: services)
        let learnCategoryListVC = LearnCategoryListViewController(viewModel: viewModel)
        learnCategoryListVC.title = R.string.localized.topTabBarItemTitleLearnStrategies()
        learnCategoryListVC.delegate = self
        let leftButton = UIBarButtonItem(withImage: R.image.ic_menu())
        let navController = UINavigationController(withPages: [learnCategoryListVC, articleCollectionViewController],
                                                   topBarDelegate: self,
                                                   pageDelegate: self,
                                                   leftButton: leftButton,
                                                   rightButton: .info)
        navController.tabBarItem = TabBarItem(config: TabBar.learn.itemConfig)
        if
            let pageViewController = navController.viewControllers.first as? PageViewController,
            let navItem = pageViewController.navigationItem as? NavigationItem,
            let whatsHotButton = navItem.middleButton(index: 1) {
                badgeManager.whatsHotBadgeContainer = (view: whatsHotButton, frame: whatsHotButton.frame)
        }
        return navController
    }()

    private lazy var topTabBarControllerMe: MyUniverseViewController = {
        let topTabBarController = MyUniverseViewController(
            config: .default,
            viewData: myUniverseProvider.viewData,
            pageTracker: pageTracker
        )
        myUniverseProvider.updateBlock = { viewData in
            topTabBarController.viewData = viewData
        }
        topTabBarController.delegate = self
        topTabBarController.tabBarItem = TabBarItem(config: TabBar.me.itemConfig)
        return topTabBarController
    }()

    lazy var topTabBarControllerPrepare: UINavigationController = {
        let leftButton = UIBarButtonItem(withImage: R.image.ic_menu())
        let topTabBarController = UINavigationController(withPages: [prepareChatViewController,
                                                                     myPrepViewController],
                                                         topBarDelegate: self,
                                                         pageDelegate: self,
                                                         backgroundImage: R.image.myprep(),
                                                         leftButton: leftButton,
                                                         rightButton: .info)
        topTabBarController.tabBarItem = TabBarItem(config: TabBar.prepare.itemConfig)
        return topTabBarController
    }()

    // MARK: - Init

    init(windowManager: WindowManager,
         selectedIndex: Index,
         services: Services,
         eventTracker: EventTracker,
         permissionsManager: PermissionsManager,
         pageTracker: PageTracker,
         syncManager: SyncManager,
         networkManager: NetworkManager) {
        self.windowManager = windowManager
        self.services = services
        self.eventTracker = eventTracker
        self.selectedIndex = Observable(selectedIndex)
        self.permissionsManager = permissionsManager
        self.pageTracker = pageTracker
        self.syncManager = syncManager
        self.networkManager = networkManager
        articleCollectionProvider = ArticleCollectionProvider(services: services)
        badgeManager = BadgeManager(services: services)

        super.init()

        articleCollectionProvider.updateBlock = { [unowned self] viewData in
            self.articleCollectionViewController.viewData = viewData
        }
    }

    // MARK: -

    func showPreparationCheckList(localID: String) {
        prepareCoordinator.showPrepareCheckList(preparationID: localID)
    }

    func start() {
        windowManager.show(tabBarController, animated: true, completion: nil)
    }

    // MARK: - private

    private func showHelp(_ section: ScreenHelp.Category) {
        let viewController = ScreenHelpViewController(configurator: ScreenHelpConfigurator.make(section))
        windowManager.showPriority(viewController, animated: true, completion: nil)
    }
}

// MARK: - TabBarControllerDelegate

extension TabBarCoordinator: TabBarControllerDelegate {

    func tabBarController(_ tabBarController: TabBarController,
                          didSelect viewController: UIViewController,
                          at index: Int) {
        if index != selectedIndex.value {
            NotificationCenter.default.post(Notification(name: .startSyncConversionRelatedData))
        }
        selectedIndex.value = index
        if let tabBarIndex = TabBar(rawValue: index) {
            badgeManager.tabDisplayed = tabBarIndex
        }
        if index == TabBar.prepare.index {
            prepareCoordinator.focus()
        }
//        syncLearnTabBadge()
    }
}

// MARK: - LearnCategoryListViewControllerDelegate

extension TabBarCoordinator: LearnCategoryListViewControllerDelegate {

    func didSelectCategory(at index: Index,
                           withFrame frame: CGRect,
                           in viewController: LearnCategoryListViewController) {
        let transitioningDelegate = LearnListAnimator()
        let coordinator = LearnContentListCoordinator(root: viewController,
                                                      transitioningDelegate: transitioningDelegate,
                                                      services: services,
                                                      eventTracker: eventTracker,
                                                      selectedCategoryIndex: index,
                                                      originFrame: frame)
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

    func myUniverseViewController(_ viewController: MyUniverseViewController?, didTap sector: StatisticsSectionType) {
        let transitioningDelegate = ChartAnimator()
        let coordinator = StatisticsCoordinator(
            root: topTabBarControllerMe,
            services: services,
            transitioningDelegate: transitioningDelegate,
            startingSection: sector,
            permissionsManager: permissionsManager
        )
        startChild(child: coordinator)
    }

    func myUniverseViewControllerDidTapVision(_ viewController: MyUniverseViewController) {
        let transitioningDelegate = MyToBeVisionAnimator()
        let coordinator = MyToBeVisionCoordinator(root: topTabBarControllerMe,
                                                  transitioningDelegate: transitioningDelegate,
                                                  services: services)
        startChild(child: coordinator)
    }

    func myUniverseViewController(_ viewController: MyUniverseViewController, didTapWeeklyChoiceAt index: Index) {
        let transitioningDelegate = WeeklyChoicesAnimator()
        let coordinator = WeeklyChoicesCoordinator(
            root: topTabBarControllerMe,
            services: services,
            transitioningDelegate: transitioningDelegate,
            topBarDelegate: nil
        )
        startChild(child: coordinator)
    }

    func myUniverseViewController(_ viewController: MyUniverseViewController, didTapQOTPartnerAt index: Index) {
        let transitioningDelegate = PartnersAnimator()
        let coordinator = PartnersCoordinator(
            root: topTabBarControllerMe,
            services: services,
            transitioningDelegate:
            transitioningDelegate,
            selectedIndex: index,
            permissionsManager: permissionsManager
        )
        startChild(child: coordinator)
    }

    func myUniverseViewController(_ viewController: MyUniverseViewController,
                                  didTapLeftBarButtonItem buttonItem: UIBarButtonItem,
                                  in topnavigationBar: NavigationItem) {
        let coordinator = SidebarCoordinator(root: tabBarController,
                                             services: services,
                                             syncManager: syncManager,
                                             networkManager: networkManager,
                                             permissionsManager: permissionsManager,
                                             destination: nil)
        startChild(child: coordinator)
    }

    func myUniverseViewController(_ viewController: MyUniverseViewController,
                                  didTapRightBarButtonItem buttonItem: UIBarButtonItem,
                                  in topnavigationBar: NavigationItem) {
        showHelp(.me)
    }
}

// MARK: - ArticleCollectionViewControllerDelegate

extension TabBarCoordinator: ArticleCollectionViewControllerDelegate {

    func didTapItem(articleHeader: ArticleCollectionHeader, in viewController: UIViewController) {
        guard
            let content = services.contentService.contentCollection(id: articleHeader.articleContentCollectionID),
            content.articleItems.count > 0 else {
                viewController.showAlert(type: .noContent, handler: nil, handlerDestructive: nil)
                return
        }

        guard let coordinator = ArticleContentItemCoordinator(pageName: .whatsHotArticle,
                                                              root: viewController,
                                                              services: services,
                                                              contentCollection: content,
                                                              articleHeader: articleHeader,
                                                              topTabBarTitle: nil,
                                                              shouldPush: false) else {
                                                                return
        }
        startChild(child: coordinator)
    }

    func viewWillAppear(in viewController: ArticleCollectionViewController) {}

    func viewDidDisappear(in viewController: ArticleCollectionViewController) {}
}

// MARK: - TopNavigationBarDelegate

 extension TabBarCoordinator: NavigationItemDelegate {

    func navigationItem(_ navigationItem: NavigationItem, leftButtonPressed button: UIBarButtonItem) {
        let coordinator = SidebarCoordinator(root: tabBarController,
                                             services: services,
                                             syncManager: syncManager,
                                             networkManager: networkManager,
                                             permissionsManager: permissionsManager,
                                             destination: nil)
        startChild(child: coordinator)
    }

    func navigationItem(_ navigationItem: NavigationItem, middleButtonPressedAtIndex index: Int, ofTotal total: Int) {
        guard
            let navigationController = tabBarController.viewControllers?[selectedIndex.value] as? UINavigationController,
            let pageViewController = navigationController.viewControllers.first as? PageViewController else {
                return
        }
        pageViewController.setPageIndex(index, animated: true)
        let pageTitle = pageViewController.currentPage?.title
        let whatsHotPageTitle = R.string.localized.topTabBarItemTitleLearnWhatsHot()
        let isWhatsHotPage = pageTitle?.caseInsensitiveCompare(whatsHotPageTitle) == .orderedSame
        badgeManager.updateWhatsHotBadge(isHidden: isWhatsHotPage)
    }

    func navigationItem(_ navigationItem: NavigationItem, rightButtonPressed button: UIBarButtonItem) {
        switch selectedIndex.value {
        case 0: showHelp(.guide)
        case 1: showHelp(.learn)
        case 2: showHelp(.me)
        case 3: showHelp(.prepare)
        default: assertionFailure("unhandled switch")
        }
    }
}

// MARK: - PageViewControllerDelegate

extension TabBarCoordinator: PageViewControllerDelegate {

    func pageViewController(_ controller: UIPageViewController, didSelectPageIndex index: Int) {
        guard let navItem = controller.navigationItem as? NavigationItem else { return }
        navItem.setIndicatorToButtonIndex(index)
    }
}
