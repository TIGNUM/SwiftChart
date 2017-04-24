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

    enum TabBarItem: Index {
        case learn = 0
        case me = 1
        case prepare = 2
    }
    
    // MARK: - Properties
    
    fileprivate let rootViewController: MainMenuViewController
    fileprivate let services: Services
    fileprivate let eventTracker: EventTracker
    fileprivate let selectedIndex: Index
    fileprivate var viewControllers = [UIViewController]()
    internal var children = [Coordinator]()

    fileprivate lazy var topTabBarControllerLearn: TopTabBarController = {
        let categories = self.services.learnContent.categories()
        let viewModel = LearnCategoryListViewModel(categories: categories)
        let learnCategoryListVC = LearnCategoryListViewController(viewModel: viewModel)
        learnCategoryListVC.delegate = self

        let whatsHotViewModel = WhatsHotViewModel()
        let whatsHotViewController = WhatsHotViewController(viewModel: whatsHotViewModel)
        whatsHotViewController.delegate = self

        let items = [
            TopTabBarController.Item(
                controller: learnCategoryListVC,
                title: R.string.localized.topTabBarItemTitleLearnStrategies().capitalized
            ),
            TopTabBarController.Item(
                controller: whatsHotViewController,
                title: R.string.localized.topTabBarItemTitleLearnWhatsHot().capitalized
            )
        ]

        return TopTabBarController(items: items, selectedIndex: 0, leftIcon: R.image.ic_search(), rightIcon: R.image.ic_menu())
    }()

    fileprivate lazy var topTabBarControllerMe: TopTabBarController = {
        let myUniverseViewController = MyUniverseViewController(
            myDataViewModel: MyDataViewModel(), myWhyViewModel: MyWhyViewModel()
        )
        myUniverseViewController.delegate = self

        let myUniverseItem = TopTabBarController.MyUniverseItem(
            controller: myUniverseViewController,
            titles: [
                R.string.localized.topTabBarItemTitleMeMyData().capitalized,
                R.string.localized.topTabBarItemTitleMeMyWhy().capitalized
            ]
        )

        return TopTabBarController(myUniverseItem: myUniverseItem, selectedIndex: 0, rightIcon: R.image.ic_menu())
    }()

    fileprivate lazy var topTabBarControllerPrepare: TopTabBarController = {
        let viewModel = ChatViewModel()
        let chatViewController = ChatViewController(viewModel: viewModel)
        chatViewController.delegate = self

        let items = [
            TopTabBarController.Item(
                controller: chatViewController,
                title: R.string.localized.topTabBarItemTitlePerpareCoach().capitalized
            ),
            TopTabBarController.Item(
                controller: chatViewController,
                title: R.string.localized.topTabBarItemTitlePerparePrep().capitalized
            )
        ]

        return TopTabBarController(items: items, selectedIndex: 0, leftIcon: R.image.ic_search(), rightIcon: R.image.ic_menu())
    }()
    
    // MARK: - Init
    
    init(rootViewController: MainMenuViewController, selectedIndex: Index, services: Services, eventTracker: EventTracker) {
        self.rootViewController = rootViewController
        self.services = services
        self.eventTracker = eventTracker
        self.selectedIndex = selectedIndex
        self.addViewControllers()
        self.addTopTabBarDelegate()
    }
}

// MARK: - TopTabBarControllers

private extension TabBarCoordinator {
    func bottomTabBarController() -> TabBarController {
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
        rootViewController.present(bottomTabBarController, animated: true)
        eventTracker.track(page: bottomTabBarController.pageID, referer: rootViewController.pageID, associatedEntity: nil)
    }

    func addViewControllers() {
        viewControllers.append(topTabBarControllerLearn)
        viewControllers.append(topTabBarControllerMe)
        viewControllers.append(topTabBarControllerPrepare)
    }

    func addTopTabBarDelegate() {
        viewControllers.forEach { (viewController: UIViewController) in
            guard let topTabBarController = viewController as? TopTabBarController else {
                return
            }

            topTabBarController.delegate = self
        }
    }
}

// MARK: - TabBarControllerDelegate

extension TabBarCoordinator: TabBarControllerDelegate {
    func didSelectTab(at index: Index, in controller: TabBarController) {
        let viewController = controller.viewControllers.first
        
        switch viewController {
        case let learnCategory as LearnCategoryListViewController: eventTracker.track(page: learnCategory.pageID, referer: rootViewController.pageID, associatedEntity: nil)
        case let meCategory as MyUniverseViewController: eventTracker.track(page: meCategory.pageID, referer: rootViewController.pageID, associatedEntity: nil)
        case let chat as ChatViewController: eventTracker.track(page: chat.pageID, referer: rootViewController.pageID, associatedEntity: nil)
        default: break
        }
    }
}

// MARK: - LearnCategoryListViewControllerDelegate

extension TabBarCoordinator: LearnCategoryListViewControllerDelegate {
    func didSelectCategory(_ category: LearnCategory, in viewController: LearnCategoryListViewController) {
        let coordinator = LearnContentListCoordinator(root: viewController, services: services, eventTracker: eventTracker, category: category)
        coordinator.start()
        coordinator.delegate = self
        children.append(coordinator)
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
        print("didTapSector: \(sector?.labelType.text ?? "INVALID")")
    }

    func didTapMyToBeVision(vision: Vision?, from view: UIView, in viewController: MyUniverseViewController) {
        let coordinator = MyToBeVisionCoordinator(root: viewControllers[TabBarItem.me.rawValue], services: services, eventTracker: eventTracker)
        coordinator.start()
        startChild(child: coordinator)
    }

    func didTapWeeklyChoices(weeklyChoice: WeeklyChoice?, from view: UIView, in viewController: MyUniverseViewController) {
        let coordinator = WeeklyChoicesCoordinator(root: viewControllers[TabBarItem.me.rawValue], services: services, eventTracker: eventTracker)
        coordinator.start()
        startChild(child: coordinator)
    }

    func didTapQOTPartner(selectedIndex: Index, partners: [Partner], from view: UIView, in viewController: MyUniverseViewController) {
        let coordinator = PartnersCoordinator(root: viewControllers[TabBarItem.me.rawValue], services: services, eventTracker: eventTracker, partners: partners, selectedIndex: selectedIndex)
        coordinator.start()
        startChild(child: coordinator)
    }
}

// MARK: - PrepareChatBotDelegate

extension TabBarCoordinator: ChatViewDelegate {
    func didSelectChatInput(_ input: ChatMessageInput, in viewController: ChatViewController) {
        log("didSelectChatInput: \(input)")
    }
    
    func didSelectChatNavigation(_ chatMessageNavigation: ChatMessageNavigation, in viewController: ChatViewController) {
        let coordinator = PrepareContentCoordinator(root: viewController, services: services, eventTracker: eventTracker)
        coordinator.start()
        coordinator.startChild(child: coordinator)
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
        if sender === topTabBarControllerMe {
            
        }

        print("didSelectRightButton", sender)
        let coordinator = SidebarCoordinator(root: sender, services: services, eventTracker: eventTracker)
        startChild(child: coordinator)
    }

    func didSelectItemAtIndex(index: Int?, sender: TopTabBarController) {
        print("didSelectItemAtIndex", index, sender)
    }
}
