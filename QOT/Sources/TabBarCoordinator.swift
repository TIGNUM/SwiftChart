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

    private let windowManager: WindowManager
    private let services: Services
    private let eventTracker: EventTracker
    private let selectedIndex: Observable<Index>
    private let permissionHandler: PermissionHandler
    private let pageTracker: PageTracker
    private let networkManager: NetworkManager
    private let syncManager: SyncManager
    private let articleCollectionProvider: ArticleCollectionProvider
    private let whatsHotBadgeManager = WhatsHotBadgeManager()
    private let sidebarMenuButton = UIBarButtonItem(withImage: R.image.ic_menu())
    var children = [Coordinator]()

    lazy var prepareCoordinator: PrepareCoordinator = {
        return PrepareCoordinator(services: self.services,
                                  eventTracker: self.eventTracker,
                                  permissionHandler: self.permissionHandler,
                                  tabBarController: self.tabBarController,
                                  topTabBarController: self.topTabBarControllerPrepare,
                                  chatViewController: self.prepareChatViewController,
                                  myPrepViewController: self.myPrepViewController)
    }()

    private lazy var prepareChatViewController: ChatViewController<Answer> = {
        let viewModel = ChatViewModel<Answer>(items: [])
        let viewController = ChatViewController(pageName: .prepareChat,
                                                viewModel: viewModel,
                                                fadeMaskLocation: .topAndBottom)
        viewController.title = R.string.localized.topTabBarItemTitlePerpareCoach()

        return viewController
    }()

    private lazy var myPrepViewController: MyPrepViewController = {
        let viewModel = MyPrepViewModel(services: self.services)
        let viewController = MyPrepViewController(viewModel: viewModel)
        viewController.title = R.string.localized.topTabBarItemTitlePerparePrep()

        return viewController
    }()

    // MARK: - tab bar

    private lazy var tabBarController: TabBarController = {
        let tabBarController = TabBarController(config: .default)
        tabBarController.modalTransitionStyle = .crossDissolve
        tabBarController.modalPresentationStyle = .custom
        tabBarController.tabBarControllerDelegate = self
        tabBarController.selectedIndex = selectedIndex.value
        tabBarController.viewControllers = [topTabBarControllerGuide,
                                            topTabBarControllerLearn,
                                            topTabBarControllerMe,
                                            topTabBarControllerPrepare]
        whatsHotBadgeManager.tabBarController = tabBarController
        whatsHotBadgeManager.isShowingLearnTab = false
        return tabBarController
    }()

    private lazy var articleCollectionViewController: ArticleCollectionViewController = {
        let viewController = ArticleCollectionViewController(pageName: .whatsHot,
                                                             viewData: articleCollectionProvider.provideViewData())
        viewController.title = R.string.localized.topTabBarItemTitleLearnWhatsHot()
        viewController.delegate = self
        return viewController
    }()

    private lazy var topTabBarControllerGuide: UINavigationController = {
        let viewModel = GuideModel()
        let guideViewController = GuideViewController(viewModel: viewModel)
        guideViewController.title = "GUIDE"
        let topTabBarController = UINavigationController(withPages: [guideViewController],
                                                         rightButton: sidebarMenuButton)
        let config = tabBarItemConfig(title: "GUIDE", tag: 0)
        topTabBarController.tabBarItem = TabBarItem(config: config)
        return topTabBarController
    }()

    private lazy var topTabBarControllerLearn: UINavigationController = {
        let viewModel = LearnCategoryListViewModel(services: services)
        let learnCategoryListVC = LearnCategoryListViewController(viewModel: viewModel)
        learnCategoryListVC.title = R.string.localized.topTabBarItemTitleLearnStrategies()
        learnCategoryListVC.delegate = self
        let topTabBarController = UINavigationController(withPages: [learnCategoryListVC,
                                                                     articleCollectionViewController],
                                                         topBarDelegate: self,
                                                         pageDelegate: self,
                                                         rightButton: sidebarMenuButton)
        let config = tabBarItemConfig(title: R.string.localized.tabBarItemLearn(), tag: 1)
        topTabBarController.tabBarItem = TabBarItem(config: config)

        guard let whatsHotButton = topTabBarController.button(at: 1) else {
            assertionFailure("expected what's hot button")
            return topTabBarController
        }

        whatsHotBadgeManager.whatsHotButton = whatsHotButton
        return topTabBarController
    }()

    private lazy var topTabBarControllerMe: MyUniverseViewController = {
        let viewModel = MyUniverseViewModel(services: services)
        let topTabBarController = MyUniverseViewController(viewModel: viewModel,
                                                           pageTracker: pageTracker
        )
        topTabBarController.delegate = self
        let config = tabBarItemConfig(title: R.string.localized.tabBarItemMe(), tag: 2)
        topTabBarController.tabBarItem = TabBarItem(config: config)
        return topTabBarController
    }()

    lazy var topTabBarControllerPrepare: UINavigationController = {
        let topTabBarController = UINavigationController(withPages: [prepareChatViewController,
                                                                     myPrepViewController],
                                                         topBarDelegate: self,
                                                         pageDelegate: self,
                                                         backgroundImage: R.image.myprep(),
                                                         leftButton: nil,
                                                         rightButton: sidebarMenuButton)
        let config = tabBarItemConfig(title: R.string.localized.tabBarItemPrepare(), tag: 3)
        topTabBarController.tabBarItem = TabBarItem(config: config)
        return topTabBarController
    }()

    private func tabBarItemConfig(title: String, tag: Int) -> TabBarItem.Config {
        var config = TabBarItem.Config.default
        config.title = title
        config.tag = tag
        return config
    }

    // MARK: - Init

    init(windowManager: WindowManager,
         selectedIndex: Index,
         services: Services,
         eventTracker: EventTracker,
         permissionHandler: PermissionHandler,
         pageTracker: PageTracker,
         syncManager: SyncManager,
         networkManager: NetworkManager) {
        self.windowManager = windowManager
        self.services = services
        self.eventTracker = eventTracker
        self.selectedIndex = Observable(selectedIndex)
        self.permissionHandler = permissionHandler
        self.pageTracker = pageTracker
        self.syncManager = syncManager
        self.networkManager = networkManager
        articleCollectionProvider = ArticleCollectionProvider(services: services)

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
        windowManager.show(tabBarController, animated: true) {
            guard let tutorial = Tutorial(rawValue: self.selectedIndex.value) else { return }
            self.showTutorial(tutorial)
        }
    }

    // MARK: - private

    private func showTutorial(_ tutorial: Tutorial) {
        guard tutorial.exists() == false,
            let buttonFrame = tabBarController.frameForButton(at: selectedIndex.value) else { return }
        tutorial.set()

        let viewModel = TutorialViewModel(tutorial: tutorial)
        let viewController = TutorialViewController(viewModel: viewModel, buttonFrame: buttonFrame) {
            self.windowManager.resignWindow(atLevel: .overlay)
        }
        viewController.modalTransitionStyle = .crossDissolve
        windowManager.showOverlay(viewController, animated: true, completion: nil)
    }
}

// MARK: - TabBarControllerDelegate

extension TabBarCoordinator: TabBarControllerDelegate {

    func tabBarController(_ tabBarController: TabBarController,
                          didSelect viewController: UIViewController,
                          at index: Int) {
        selectedIndex.value = index
        whatsHotBadgeManager.isShowingLearnTab = (index == 1)

        if index == 3 {
            prepareCoordinator.focus()
        }

        guard let tutorial = Tutorial(rawValue: index) else { return }
        showTutorial(tutorial)
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

    func didTapRightBarButton(_ button: UIBarButtonItem,
                              from topNavigationBar: TopNavigationBar,
                              in viewController: MyUniverseViewController) {
        self.topNavigationBar(topNavigationBar, rightButtonPressed: button)
    }

    func didTapSector(startingSection: StatisticsSectionType?, in viewController: MyUniverseViewController) {
        let transitioningDelegate = ChartAnimator()
        let coordinator = StatisticsCoordinator(root: topTabBarControllerMe,
                                                services: services,
                                                transitioningDelegate: transitioningDelegate,
                                                startingSection: startingSection)
        startChild(child: coordinator)
    }

    func didTapMyToBeVision(from view: UIView, in viewController: MyUniverseViewController) {
        let transitioningDelegate = MyToBeVisionAnimator()
        let coordinator = MyToBeVisionCoordinator(root: topTabBarControllerMe,
                                                  transitioningDelegate: transitioningDelegate,
                                                  services: services, permissionHandler: permissionHandler)
        startChild(child: coordinator)
    }

    func didTapWeeklyChoices(from view: UIView, in viewController: MyUniverseViewController) {
        let transitioningDelegate = WeeklyChoicesAnimator()
        let coordinator = WeeklyChoicesCoordinator(root: topTabBarControllerMe,
                                                   services: services,
                                                   transitioningDelegate: transitioningDelegate,
                                                   topBarDelegate: nil)
        startChild(child: coordinator)
    }

    func didTapQOTPartner(selectedIndex: Index, from view: UIView, in viewController: MyUniverseViewController) {
        let transitioningDelegate = PartnersAnimator()
        let coordinator = PartnersCoordinator(root: topTabBarControllerMe,
                                              services: services,
                                              transitioningDelegate: transitioningDelegate,
                                              selectedIndex: selectedIndex,
                                              permissionHandler: permissionHandler)
        startChild(child: coordinator)
    }
}

// MARK: - ArticleCollectionViewControllerDelegate

extension TabBarCoordinator: ArticleCollectionViewControllerDelegate {

    func didTapItem(articleHeader: ArticleCollectionHeader, in viewController: ArticleCollectionViewController) {
        guard
            let content = services.contentService.contentCollection(id: articleHeader.articleContentCollectionID),
            content.articleItems.count > 0 else {
                viewController.showAlert(type: .noContent, handler: nil, handlerDestructive: nil)
                return
        }

        guard let coordinator = ArticleContentItemCoordinator(
            pageName: .whatsHotArticle,
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
}

// MARK: - TopNavigationBarDelegate

extension TabBarCoordinator: TopNavigationBarDelegate {

    func topNavigationBar(_ navigationBar: TopNavigationBar, leftButtonPressed button: UIBarButtonItem) {}

    func topNavigationBar(_ navigationBar: TopNavigationBar,
                          middleButtonPressed button: UIButton,
                          withIndex index: Int,
                          ofTotal total: Int) {
        guard
            let navigationController = tabBarController.viewControllers?[selectedIndex.value] as? UINavigationController,
            let pageViewController = navigationController.viewControllers.first as? PageViewController else {
                return
        }

        pageViewController.setPageIndex(index, animated: true)
    }

    func topNavigationBar(_ navigationBar: TopNavigationBar, rightButtonPressed button: UIBarButtonItem) {
        let coordinator = SidebarCoordinator(root: tabBarController,
                                             services: services,
                                             syncManager: syncManager,
                                             networkManager: networkManager)
        startChild(child: coordinator)
    }
}

// MARK: - PageViewControllerDelegate

extension TabBarCoordinator: PageViewControllerDelegate {

    func pageViewController(_ controller: UIPageViewController, didSelectPageIndex index: Int) {
        guard
            let navigationController = controller.navigationController,
            let topNavigationBar = navigationController.navigationBar as? TopNavigationBar else {
                return
        }

        topNavigationBar.setIndicatorToButtonIndex(index)

        if selectedIndex.value == 0 && index == 1 {
            whatsHotBadgeManager.didScrollToWhatsHotPage()
        }
    }
}
