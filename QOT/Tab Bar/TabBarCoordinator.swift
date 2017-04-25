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
            myDataViewModel: MyDataViewModel(),
            myWhyViewModel: MyWhyViewModel()
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

    func didTapMyToBeVision(vision: Vision?, from view: UIView) {
        let coordinator = MyToBeVisionCoordinator(root: topTabBarControllerMe, services: services, eventTracker: eventTracker)
        startChild(child: coordinator)
    }

    func didTapWeeklyChoices(weeklyChoice: WeeklyChoice?, from view: UIView) {
        let coordinator = WeeklyChoicesCoordinator(root: topTabBarControllerMe, services: services, eventTracker: eventTracker)
        startChild(child: coordinator)
    }

    func didTapQOTPartner(selectedIndex: Index, partners: [Partner], from view: UIView) {
        let coordinator = PartnersCoordinator(root: topTabBarControllerMe, services: services, eventTracker: eventTracker, partners: partners, selectedIndex: selectedIndex)
        startChild(child: coordinator)
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

        // TODO: Update associatedEntity with realm object when its created.
        eventTracker.track(page: prepareContentViewController.pageID, referer: rootViewController.pageID, associatedEntity: nil)
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

    func didTapSaveAs(sectionID: String, in viewController: PrepareContentViewController) {
        let viewModel = MyPrepViewModel()
        let vc = MyPrepViewController(viewModel: viewModel)
        viewController.present(vc, animated: true)
    }

    func didTapAddToNotes(sectionID: String, in viewController: PrepareContentViewController) {
        log("didTapAddToNotes")
    }

    func didTapAddPreparation(sectionID: String, in viewController: PrepareContentViewController) {
        let viewModel = PrepareEventsViewModel()
        let vc = PrepareEventsViewController(viewModel: viewModel)
        viewController.present(vc, animated: true)
    }

    func didTapSaveAs(in viewController: PrepareContentViewController) {
        let viewModel = MyPrepViewModel()
        let vc = MyPrepViewController(viewModel: viewModel)
        viewController.present(vc, animated: true)
    }

    func didTapAddToNotes(in viewController: PrepareContentViewController) {
        log("didTapAddToNotes")
    }

    func didTapAddPreparation(in viewController: PrepareContentViewController) {
        let viewModel = PrepareEventsViewModel()
        let vc = PrepareEventsViewController(viewModel: viewModel)
        viewController.present(vc, animated: true)
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
        case .media(let localID, let placeholderURL, let description):
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

// MARK: - WhatsHotNewTemplateViewControllerDelegate

extension TabBarCoordinator: WhatsHotNewTemplateViewControllerDelegate {
    func didTapClose(in viewController: WhatsHotNewTemplateViewController) {
        viewController.dismiss(animated: true, completion: nil)
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
        let coordinator = SidebarCoordinator(root: sender, services: services, eventTracker: eventTracker)
        startChild(child: coordinator)
    }

    func didSelectItemAtIndex(index: Int?, sender: TopTabBarController) {
        print("didSelectItemAtIndex", index, sender)
    }
}
