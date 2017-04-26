//
//  LearnStrategyCoordinator.swift
//  QOT
//
//  Created by tignum on 3/30/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class LearnStrategyCoordinator: ParentCoordinator {
    fileprivate let rootVC: LearnContentListViewController
    fileprivate let services: Services
    fileprivate let eventTracker: EventTracker
    fileprivate let category: LearnCategory
    var children: [Coordinator] = []
    
    init(root: LearnContentListViewController, services: Services, eventTracker: EventTracker, category: LearnCategory) {
        self.rootVC = root
        self.services = services
        self.eventTracker = eventTracker
        self.category = category
    }
    
    func start() {
        let viewModel = LearnStrategyViewModel()
        let vc = LearnStrategyViewController(viewModel: viewModel)
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .custom
        vc.delegate =  self

        let topTabBarControllerItem = TopTabBarController.Item(
            controllers: [vc],
            titles: [R.string.localized.topTabBarItemTitleLearnStrategies()]
        )

        let topTabBarController = TopTabBarController(
            item: topTabBarControllerItem,
            leftIcon: R.image.ic_minimize(),
            rightIcon: R.image.ic_bookmark()
        )

        topTabBarController.delegate = self
        rootVC.present(topTabBarController, animated: true)
        
        // FIXME: Add page tracking
    }
}

extension LearnStrategyCoordinator: LearnContentListViewControllerDelegate {
    func didSelectContent(at index: Index, in viewController: LearnContentListViewController) {
        log("Did select content at index: \(index)")
    }
    
    func didTapBack(in: LearnContentListViewController) {
        rootVC.dismiss(animated: true)
        removeChild(child: self)
    }
}

extension LearnStrategyCoordinator: LearnStrategyViewControllerDelegate {
    func didTapClose(in viewController: LearnStrategyViewController) {
        rootVC.dismiss(animated: true, completion: nil)
        removeChild(child: self)
    }
    
    func didTapShare(in viewController: LearnStrategyViewController) {
        log("did tap share")
    }
    
    func didTapVideo(with video: LearnStrategyItem, from view: UIView, in viewController: LearnStrategyViewController) {
        log("did tap video: \(video)")
    }
    
    func didTapArticle(with article: LearnStrategyItem, from view: UIView, in viewController: LearnStrategyViewController) {
        log("did tap article: \(article)")
    }
}

extension LearnStrategyCoordinator: TopTabBarDelegate {

    func didSelectItemAtIndex(index: Int?, sender: TopTabBarController) {
        print(index, sender)
    }

    func didSelectLeftButton(sender: TopTabBarController) {
        sender.dismiss(animated: true, completion: nil)
    }

    func didSelectRightButton(sender: TopTabBarController) {
        print("did select book mark")
    }
}
