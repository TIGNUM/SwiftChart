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
    var children = [Coordinator]()

    fileprivate lazy var topTabBarControllerLearn: TopTabBarController = {
        let categories = self.services.learnContentService.categories()
        let whatsHotCategories = self.services.learnWhatsHotService.categories()
        let whatsHotContentCollections = self.services.learnWhatsHotService.contentCollections(for: whatsHotCategories)
        let viewModel = LearnCategoryListViewModel(categories: categories)
        let learnCategoryListVC = LearnCategoryListViewController(viewModel: viewModel)
        let whatsHotViewModel = WhatsHotViewModel(categories: whatsHotCategories, contentCollections: whatsHotContentCollections)
        let whatsHotViewController = WhatsHotViewController(viewModel: whatsHotViewModel)

        let topBarControllerItem = TopTabBarController.Item(
            controllers: [learnCategoryListVC, whatsHotViewController],
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

        whatsHotViewController.delegate = self
        topTabBarController.delegate = self
        learnCategoryListVC.delegate = self
        self.services.learnContentService.learnCategoryUpdateDelegate = learnCategoryListVC

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
        let prepareContentCategory = self.services.prepareContentService.categories().item(at: 0)
        let chatViewModel = ChatViewModel<PrepareChatChoice>(items: mockPrepareChatItems())
        let chatViewController = ChatViewController(viewModel: chatViewModel)
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

        chatViewController.didSelectChoice = { [weak self] (choice, viewController) in
            print(choice)
            // FIXME: Implement next logic
            // let coordinator = PrepareContentCoordinator(root: viewController, services: services, eventTracker: eventTracker, collection: chatMessageNavigation)
            // coordinator.startChild(child: coordinator)
        }

        topTabBarController.delegate = self
        
        return topTabBarController
    }()
    
    // MARK: - Init
    
    init(window: UIWindow, selectedIndex: Index, services: Services, eventTracker: EventTracker) {
        self.window = window
        self.services = services
        self.eventTracker = eventTracker
        self.selectedIndex = selectedIndex
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
        let viewController = controller.viewControllers.first
        
        switch viewController {
        case let learnCategory as LearnCategoryListViewController: eventTracker.track(page: learnCategory.pageID, referer: learnCategory.pageID, associatedEntity: nil)
        case let meCategory as MyUniverseViewController: eventTracker.track(page: meCategory.pageID, referer: meCategory.pageID, associatedEntity: nil)
        case let chat as ChatViewController<PrepareChatChoice>: eventTracker.track(page: chat.pageID, referer: chat.pageID, associatedEntity: nil)
        default: break
        }
    }
}

// MARK: - LearnCategoryListViewControllerDelegate

extension TabBarCoordinator: LearnCategoryListViewControllerDelegate {

    func didSelectCategory(at index: Index, category: LearnContentCategory, in viewController: LearnCategoryListViewController) {
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

// MARK: - WhatsHotViewControllerDelegate

extension TabBarCoordinator: WhatsHotViewControllerDelegate {

    func didTapVideo(at index: Index, with whatsHot: LearnWhatsHotContentItem, from view: UIView, in viewController: WhatsHotViewController) {
        log("didTapVideo: index: \(index)")
    }

    func didTapBookmark(at index: Index, with whatsHot: LearnWhatsHotContentItem, in view: UIView, in viewController: WhatsHotViewController) {
        log("didTapBookmark: index: \(index)")
    }
}

// MARK: - WhatsHotNewTemplateViewControllerDelegate

extension TabBarCoordinator: WhatsHotNewTemplateViewControllerDelegate {

    func didTapClose(in viewController: WhatsHotNewTemplateViewController) {
        viewController.dismiss(animated: true, completion: nil)
        removeChild(child: self)
    }

    func didTapLoadMore(from view: UIView, in viewController: WhatsHotNewTemplateViewController) {
        log("didTapLoadMore")
    }

    func didTapBookmark(with item: WhatsHotNewTemplateItem, in viewController: WhatsHotNewTemplateViewController) {
        log("didTapBookmark, item: \(item)")
    }

    func didTapMedia(with mediaItem: WhatsHotNewTemplateItem, from view: UIView, in viewController: WhatsHotNewTemplateViewController) {
        log("didTapMedia")
    }

    func didTapArticle(with articleItem: WhatsHotNewTemplateItem, from view: UIView, in viewController: WhatsHotNewTemplateViewController) {
        log("didTapArticle")
    }

    func didTapLoadMoreItem(with loadMoreItem: WhatsHotNewTemplateItem, from view: UIView, in viewController: WhatsHotNewTemplateViewController) {
        log("didTapLoadMoreItem: with item: \(loadMoreItem)")
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
