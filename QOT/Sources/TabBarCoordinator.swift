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

final class TabBarCoordinator: ParentCoordinator {

    // MARK: - Properties

    fileprivate let windowManager: WindowManager
    fileprivate let services: Services
    fileprivate let eventTracker: EventTracker
    fileprivate let selectedIndex: Observable<Index>
    fileprivate var viewControllers = [UIViewController]()
    fileprivate var tabBarController: TabBarController?
    fileprivate let permissionHandler: PermissionHandler
    fileprivate var preparationID: String?
    fileprivate var hasLoadedFirstTime = false
    fileprivate let pageTracker: PageTracker
    var children = [Coordinator]()

    var isLoading: Bool {
        return windowManager.rootViewController(atLevel: .normal)?.presentedViewController is LoadingViewController
    }
    
    lazy private var syncAllStartedNotificationHandler: NotificationHandler = {
        return NotificationHandler(name: .syncAllDidStartNotification)
    }()

    lazy private var syncAllFinishedNotificationHandler: NotificationHandler = {
        return NotificationHandler(name: .syncAllDidFinishNotification)
    }()

    fileprivate lazy var prepareCoordinator: PrepareCoordinator = {
        return PrepareCoordinator(services: self.services,
                                  eventTracker: self.eventTracker,
                                  permissionHandler: self.permissionHandler,
                                  tabBarController: self.tabBarController!,
                                  topTabBarController: self.topTabBarControllerPrepare,
                                  chatViewController: self.prepareChatViewController,
                                  myPrepViewController: self.myPrepViewController)
    }()
    fileprivate lazy var prepareChatViewController: ChatViewController<Answer> = {
        let viewModel = ChatViewModel<Answer>(items: [])
        let viewController = ChatViewController(pageName: .prepareChat, viewModel: viewModel)
        viewController.title = R.string.localized.topTabBarItemTitlePerpareCoach()

        return viewController
    }()

    fileprivate lazy var myPrepViewController: MyPrepViewController = {
        let viewModel = MyPrepViewModel(services: self.services)
        let viewController = MyPrepViewController(viewModel: viewModel)
        viewController.title = R.string.localized.topTabBarItemTitlePerparePrep()

        return viewController
    }()

    fileprivate lazy var topTabBarControllerLearn: UINavigationController = {
        let viewModel = LearnCategoryListViewModel(services: self.services)
        let learnCategoryListVC = LearnCategoryListViewController(viewModel: viewModel)
        learnCategoryListVC.title = R.string.localized.topTabBarItemTitleLearnStrategies()
        learnCategoryListVC.delegate = self
        let articleCollectionViewModel = ArticleCollectionViewModel(services: self.services)
        let articleCollectionViewController = ArticleCollectionViewController(pageName: .whatsHot, viewModel: articleCollectionViewModel)
        articleCollectionViewController.title = R.string.localized.topTabBarItemTitleLearnWhatsHot()
        articleCollectionViewController.delegate = self
        let rightButton = UIBarButtonItem(withImage: R.image.ic_menu())
        let topTabBarController = UINavigationController(withPages: [learnCategoryListVC, articleCollectionViewController],
                                                         topBarDelegate: self,
                                                         pageDelegate: self,
                                                         rightButton: rightButton)

        return topTabBarController
    }()

    fileprivate lazy var topTabBarControllerMe: MyUniverseViewController = {
        let myUniverseViewController = MyUniverseViewController(
            myDataViewModel: MyDataViewModel(services: self.services),
            myWhyViewModel: MyWhyViewModel(services: self.services),
            pageTracker: self.pageTracker
        )
        myUniverseViewController.delegate = self
        return myUniverseViewController
    }()

    fileprivate lazy var topTabBarControllerPrepare: UINavigationController = {
        let rightButton = UIBarButtonItem(withImage: R.image.ic_menu())        
        let topTabBarController = UINavigationController(withPages: [self.prepareChatViewController, self.myPrepViewController],
                                                         topBarDelegate: self,
                                                         pageDelegate: self,
                                                         backgroundImage: R.image.myprep(),
                                                         leftButton: nil,
                                                         rightButton: rightButton)
        return topTabBarController
    }()

    lazy private var loadingViewController: LoadingViewController = {
        let vc = LoadingViewController()
        vc.modalTransitionStyle = .crossDissolve
        return vc
    }()

    // MARK: - Init
    
    init(windowManager: WindowManager, selectedIndex: Index, services: Services, eventTracker: EventTracker, permissionHandler: PermissionHandler, pageTracker: PageTracker) {
        self.windowManager = windowManager
        self.services = services
        self.eventTracker = eventTracker
        self.selectedIndex = Observable(selectedIndex)
        self.permissionHandler = permissionHandler
        self.pageTracker = pageTracker
        
        syncAllStartedNotificationHandler.handler = { (notification: Notification) in
            guard let userInfo = notification.userInfo, let isDownloadRecordsValid = userInfo["isDownloadRecordsValid"] as? Bool, isDownloadRecordsValid == false, !self.hasLoadedFirstTime else {
                return
            }
            self.showLoading()
        }

        syncAllFinishedNotificationHandler.handler = { (_: Notification) in
            self.hasLoadedFirstTime = true
            self.hideLoading(completion: {
                if let preparationID = self.preparationID {
                    self.prepareCoordinator.showPrepareCheckList(preparationID: preparationID)
                }
            })
        }
    }

    // MARK: -

    func showPreparationCheckList(localID: String) {
        if hasLoadedFirstTime {
            prepareCoordinator.showPrepareCheckList(preparationID: localID)
        } else {
            preparationID = localID
        }
    }
    
    func showLoading(completion: (() -> Void)? = nil) {
        guard !isLoading else {
            return
        }

        windowManager.presentViewController(loadingViewController, atLevel: .normal, animated: true, completion: nil)
        loadingViewController.fadeIn(withCompletion: completion)
    }
    
    func hideLoading(completion: (() -> Void)? = nil) {
        guard isLoading else {
            completion?()
            return
        }
        
        let loadingViewController = self.loadingViewController
        loadingViewController.fadeOut(withCompletion: { [unowned loadingViewController] in
            loadingViewController.dismiss(animated: true, completion: {
                completion?()
            })
        })
    }
    
    func start() {
        viewControllers.append(topTabBarControllerLearn)
        viewControllers.append(topTabBarControllerMe)
        viewControllers.append(topTabBarControllerPrepare)
        tabBarController = bottomTabBarController()
        windowManager.setRootViewController(tabBarController!, atLevel: .normal, animated: true, completion: nil)
    }
    
    // MARK: - private
    
    private func bottomTabBarController() -> TabBarController {
        let bottomTabBarController = TabBarController(items: tabBarControllerItems(), selectedIndex: selectedIndex.value)
        bottomTabBarController.modalTransitionStyle = .crossDissolve
        bottomTabBarController.modalPresentationStyle = .custom
        bottomTabBarController.delegate = self
        return bottomTabBarController
    }
    
    private func tabBarControllerItems() -> [TabBarController.Item] {
        return [
            TabBarController.Item(controller: topTabBarControllerLearn, title: R.string.localized.tabBarItemLearn()),
            TabBarController.Item(controller: topTabBarControllerMe, title: R.string.localized.tabBarItemMe()),
            TabBarController.Item(controller: topTabBarControllerPrepare, title: R.string.localized.tabBarItemPrepare())
        ]
    }
    
    fileprivate func showTutorial(_ tutorial: Tutorial) {
        guard !tutorial.exists(), let tabBarView = tabBarController?.tabBarView else {
            return
        }

        tutorial.set()
        let selectedIndex = self.selectedIndex.value
        let viewModel = TutorialViewModel(tutorial: tutorial)
        let buttonFrame = tabBarView.buttons[selectedIndex].frame
        let viewController = TutorialViewController(viewModel: viewModel, buttonFrame: buttonFrame) {
            tabBarView.setGlowEffectForButtonIndex(selectedIndex, enabled: false)
            self.windowManager.resignWindow(atLevel: .overlay)
        }
        windowManager.showWindow(atLevel: .overlay)
        windowManager.setRootViewController(viewController, atLevel: .overlay, animated: true) {
            tabBarView.setGlowEffectForButtonIndex(selectedIndex, enabled: true)
        }
    }
}

// MARK: - TabBarControllerDelegate

extension TabBarCoordinator: TabBarControllerDelegate {

    func didSelectTab(at index: Index, in controller: TabBarController) {        
        selectedIndex.value = index

        switch index {
        case 2:
            prepareCoordinator.focus()
        default:
            break
        }

        guard let tutorial = Tutorial(rawValue: index) else {
            return
        }
        showTutorial(tutorial)
    }

    func viewDidAppear() {
        guard let tutorial = Tutorial(rawValue: selectedIndex.value) else {
            return
        }
        showTutorial(tutorial)
    }
}

// MARK: - LearnCategoryListViewControllerDelegate

extension TabBarCoordinator: LearnCategoryListViewControllerDelegate {

    func didSelectCategory(at index: Index, withFrame frame: CGRect, in viewController: LearnCategoryListViewController) {
        let transitioningDelegate = LearnListAnimator()
        let coordinator = LearnContentListCoordinator(root: viewController, transitioningDelegate: transitioningDelegate, services: services, eventTracker: eventTracker, selectedCategoryIndex: index, originFrame: frame)
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

    func didTapRightBarButton(_ button: UIBarButtonItem, from topNavigationBar: TopNavigationBar, in viewController: MyUniverseViewController) {
        self.topNavigationBar(topNavigationBar, rightButtonPressed: button)
    }

    func didTapSector(startingSection: StatisticsSectionType?, in viewController: MyUniverseViewController) {
        let transitioningDelegate = ChartAnimator()
        let coordinator = StatisticsCoordinator(root: topTabBarControllerMe, services: services, transitioningDelegate: transitioningDelegate, startingSection: startingSection)
        startChild(child: coordinator)
    }

    func didTapMyToBeVision(vision: MyToBeVision?, from view: UIView, in viewController: MyUniverseViewController) {
        let transitioningDelegate = MyToBeVisionAnimator()
        let coordinator = MyToBeVisionCoordinator(root: topTabBarControllerMe, transitioningDelegate: transitioningDelegate, services: services, permissionHandler: permissionHandler)
        startChild(child: coordinator)
    }

    func didTapWeeklyChoices(weeklyChoice: WeeklyChoice?, from view: UIView, in viewController: MyUniverseViewController) {
        let transitioningDelegate = WeeklyChoicesAnimator()
        let coordinator = WeeklyChoicesCoordinator(root: topTabBarControllerMe, services: services, transitioningDelegate: transitioningDelegate)
        startChild(child: coordinator)
    }

    func didTapQOTPartner(selectedIndex: Index, partners: [Partner], from view: UIView, in viewController: MyUniverseViewController) {
        let transitioningDelegate = PartnersAnimator()
        let coordinator = PartnersCoordinator(root: topTabBarControllerMe, services: services, transitioningDelegate: transitioningDelegate, selectedIndex: selectedIndex, permissionHandler: permissionHandler)
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

        guard let coordinator = ArticleContentItemCoordinator(
            pageName: .whatsHotArticle,
            root: viewController,
            services: services,
            contentCollection: articleHeader.articleContentCollection,
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

    func topNavigationBar(_ navigationBar: TopNavigationBar, leftButtonPressed button: UIBarButtonItem) {
        
    }
    
    func topNavigationBar(_ navigationBar: TopNavigationBar, middleButtonPressed button: UIButton, withIndex index: Int, ofTotal total: Int) {
        guard let navigationController = viewControllers[selectedIndex.value] as? UINavigationController, let pageViewController = navigationController.viewControllers.first as? PageViewController else {
            return
        }

        pageViewController.setPageIndex(index, animated: true)
    }
    
    func topNavigationBar(_ navigationBar: TopNavigationBar, rightButtonPressed button: UIBarButtonItem) {
        guard let tabBarController = tabBarController else {
            return
        }

        let coordinator = SidebarCoordinator(root: tabBarController, services: services)
        startChild(child: coordinator)
    }
}

// MARK: - PageViewControllerDelegate

extension TabBarCoordinator: PageViewControllerDelegate {
    func pageViewController(_ controller: UIPageViewController, didSelectPageIndex index: Int) {
        guard let navigationController = controller.navigationController, let topNavigationBar = navigationController.navigationBar as? TopNavigationBar else {
            return
        }
        
        topNavigationBar.setIndicatorToButtonIndex(index)
    }
}
