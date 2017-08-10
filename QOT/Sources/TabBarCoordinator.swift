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

    fileprivate let window: UIWindow
    fileprivate let services: Services
    fileprivate let selectedIndex: Observable<Index>
    fileprivate var tutorialDispatchWorkItem: DispatchWorkItem?
    fileprivate var viewControllers = [UIViewController]()
    fileprivate var tabBarController: TabBarController?
    fileprivate let permissionHandler: PermissionHandler

    fileprivate var preparationID: String?
    fileprivate var hasLoaded = false
    fileprivate var hasStarted = false

    fileprivate var disposeBag = DisposeBag()
    
    lazy private var syncStartedNotificationHandler: NotificationHandler = {
        return NotificationHandler(name: .syncStartedNotification)
    }()
    lazy private var syncFinishedNotificationHandler: NotificationHandler = {
        return NotificationHandler(name: .syncFinishedNotification)
    }()
    
    fileprivate lazy var prepareCoordinator: PrepareCoordinator = {
        return PrepareCoordinator(services: self.services,
                                  permissionHandler: self.permissionHandler,
                                  tabBarController: self.tabBarController!,
                                  topTabBarController: self.topTabBarControllerPrepare,
                                  chatViewController: self.prepareChatViewController,
                                  myPrepViewController: self.myPrepViewController)
    }()

    var children = [Coordinator]()

    fileprivate lazy var prepareChatViewController: ChatViewController<Answer> = {
        let viewModel = ChatViewModel<Answer>()
        let viewController = ChatViewController(viewModel: viewModel)
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
        let articleCollectionViewController = ArticleCollectionViewController(viewModel: articleCollectionViewModel)
        articleCollectionViewController.title = R.string.localized.topTabBarItemTitleLearnWhatsHot()
        articleCollectionViewController.delegate = self

//        let leftButton = UIBarButtonItem(withImage: R.image.ic_search())
        let rightButton = UIBarButtonItem(withImage: R.image.ic_menu())
        let topTabBarController = UINavigationController(withPages: [learnCategoryListVC, articleCollectionViewController], topBarDelegate: self, pageDelegate: self, leftButton: nil, rightButton: rightButton)
        
        return topTabBarController
    }()

    fileprivate lazy var topTabBarControllerMe: MyUniverseViewController = {
        let myUniverseViewController = MyUniverseViewController(
            myDataViewModel: MyDataViewModel(services: self.services),
            myWhyViewModel: MyWhyViewModel(services: self.services)
        )
        myUniverseViewController.delegate = self
        return myUniverseViewController
    }()

    fileprivate lazy var topTabBarControllerPrepare: UINavigationController = {
//        let leftButton = UIBarButtonItem(withImage: R.image.ic_search())
        let rightButton = UIBarButtonItem(withImage: R.image.ic_menu())
        let topTabBarController = UINavigationController(withPages: [self.prepareChatViewController, self.myPrepViewController], topBarDelegate: self, pageDelegate: self, leftButton: nil, rightButton: rightButton)
        
        return topTabBarController
    }()
    
    lazy private var loadingViewController: LoadingViewController = {
        let vc = LoadingViewController()
        vc.modalTransitionStyle = .crossDissolve
        return vc
    }()
    
    var isLoading: Bool {
        return window.rootViewController is LoadingViewController
    }
    
    // MARK: - Init
    
    init(window: UIWindow, selectedIndex: Index, services: Services, permissionHandler: PermissionHandler) {
        self.window = window
        self.services = services
        self.selectedIndex = Observable(selectedIndex)
        self.permissionHandler = permissionHandler
        
        syncStartedNotificationHandler.handler = { [weak self] (notification: Notification) in
            guard let `self` = self, let userInfo = notification.userInfo, let isSyncRecordsValid = userInfo["isSyncRecordsValid"] as? Bool, isSyncRecordsValid == false else {
                return
            }
            self.showLoading()
        }
        syncFinishedNotificationHandler.handler = { [weak self] (_: Notification) in
            guard let `self` = self, self.tabBarController?.presentedViewController == self.loadingViewController else {
                return
            }
            self.loadingViewController.fadeOut(withCompletion: {
                self.loadingViewController.dismiss(animated: true, completion: {
                    self.hasLoaded = true
                    if let preparationID = self.preparationID {
                        self.prepareCoordinator.showPrepareCheckList(preparationID: preparationID)
                    } else {
                        if self.hasStarted {
                            self.startTutorials()
                        }
                    }
                })
            })
        }
    }

    // MARK: -

    func showPreparationCheckList(localID: String) {
        if hasLoaded {
            prepareCoordinator.showPrepareCheckList(preparationID: localID)
        } else {
            preparationID = localID
        }
    }
    
    func showLoading() {
        window.rootViewController?.present(self.loadingViewController, animated: false, completion: nil)
        loadingViewController.fadeIn()
    }
}

// MARK: - TopTabBarControllers

private extension TabBarCoordinator {
    
    func bottomTabBarController() -> TabBarController {
        addViewControllers()
        let bottomTabBarController = TabBarController(items: tabBarControllerItems(), selectedIndex: selectedIndex.value)
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
        tabBarController = bottomTabBarController()
        window.setRootViewControllerWithFadeAnimation(tabBarController!)
        window.makeKeyAndVisible()
        hasStarted = true

        if hasLoaded {
            startTutorials()
        }
    }

    func addViewControllers() {
        viewControllers.append(topTabBarControllerLearn)
        viewControllers.append(topTabBarControllerMe)
        viewControllers.append(topTabBarControllerPrepare)
    }
}

// MARK: - Private

private extension TabBarCoordinator {

    func startTutorials() {
        self.selectedIndex.observeNext { [unowned self] value in
            let tutorial: Tutorials = (value == 0 ? .learnTutorial : (value == 1 ? .meTutorial : .prepareTutorial))

            self.tutorialDispatchWorkItem?.cancel()

            if !tutorial.exists() {

                let dispatchWorkItem = DispatchWorkItem { [unowned self] in
                    self.tabBarController?.tutorial(show: true)
                    AppDelegate.current.appCoordinator.showTutorial(tutorial, buttonFrame: self.tabBarController?.buttonFrame()) { [unowned self] in
                        print("Completion block for tutorial")
                        self.tabBarController?.tutorial(show: false)
                        tutorial.set()
                    }
                }

                self.tutorialDispatchWorkItem = dispatchWorkItem

                DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: dispatchWorkItem)
            }
            }
            .dispose(in: disposeBag)
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
    }
}

// MARK: - LearnCategoryListViewControllerDelegate

extension TabBarCoordinator: LearnCategoryListViewControllerDelegate {

    func didSelectCategory(at index: Index, withFrame frame: CGRect, in viewController: LearnCategoryListViewController) {
        let coordinator = LearnContentListCoordinator(root: viewController, services: services, selectedCategoryIndex: index, originFrame: frame)
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

    func didTapSector(startingSection: MyStatisticsSectionType?, in viewController: MyUniverseViewController) {
        let coordinator = MyStatisticsCoordinator(root: topTabBarControllerMe, services: services, startingSection: startingSection)
        startChild(child: coordinator)
    }

    func didTapMyToBeVision(vision: MyToBeVision?, from view: UIView, in viewController: MyUniverseViewController) {
        let coordinator = MyToBeVisionCoordinator(root: topTabBarControllerMe, services: services)
        startChild(child: coordinator)
    }

    func didTapWeeklyChoices(weeklyChoice: WeeklyChoice?, from view: UIView, in viewController: MyUniverseViewController) {
        let coordinator = WeeklyChoicesCoordinator(root: topTabBarControllerMe, services: services)
        startChild(child: coordinator)
    }

    func didTapQOTPartner(selectedIndex: Index, partners: [Partner], from view: UIView, in viewController: MyUniverseViewController) {
        let coordinator = PartnersCoordinator(root: topTabBarControllerMe, services: services, selectedIndex: selectedIndex)
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
            root: viewController,
            services: services,
            contentCollection: articleHeader.articleContentCollection,
            articleHeader: articleHeader,
            topTabBarTitle: nil) else {
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
