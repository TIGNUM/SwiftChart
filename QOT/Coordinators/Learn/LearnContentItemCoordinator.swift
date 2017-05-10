//
//  LearnContentItemCoordinator.swift
//  QOT
//
//  Created by tignum on 3/30/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class LearnContentItemCoordinator: ParentCoordinator {
    fileprivate let rootVC: LearnContentListViewController
    fileprivate let services: Services
    fileprivate let eventTracker: EventTracker
    fileprivate let category: LearnContentCategory
    fileprivate let selectedCategoryIndex: Index
    var children: [Coordinator] = []
    
    init(root: LearnContentListViewController, services: Services, eventTracker: EventTracker, category: LearnContentCategory, at index: Index) {
        self.rootVC = root
        self.services = services
        self.eventTracker = eventTracker
        self.category = category
        self.selectedCategoryIndex = index
    }
    
    func start() {
        let viewModel = LearnContentItemViewModel(contentCollection: category.learnContent.item(at: selectedCategoryIndex))
        let vc = LearnContentItemViewController(viewModel: viewModel)
        let audioViewModel = LearnStrategyAudioViewModel()
        let audioViewController = LearnStrategyAudioViewController(viewModel: audioViewModel)
        let bulletViewCOntroller = LearnContentItemBulletViewController(viewModel: viewModel)

        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .custom

        let topTabBarControllerItem = TopTabBarController.Item(
            controllers: [vc, bulletViewCOntroller, audioViewController],
            titles: [
                R.string.localized.learnContentItemTitleFull(),
                R.string.localized.learnContentItemTitleBullets(),
                R.string.localized.learnContentItemTitleAudio()
            ],
            theme: .light
        )

        let topTabBarController = TopTabBarController(
            item: topTabBarControllerItem,
            leftIcon: R.image.ic_minimize()
        )

        vc.delegate = self
        vc.serviceDelegate = services
        topTabBarController.delegate = self
        rootVC.present(topTabBarController, animated: true)
        
        // FIXME: Add page tracking
    }
}

extension LearnContentItemCoordinator: LearnContentListViewControllerDelegate {
    func didSelectContent(at index: Index, in viewController: LearnContentListViewController) {
        log("Did select content at index: \(index)")
    }
    
    func didTapBack(in: LearnContentListViewController) {
        rootVC.dismiss(animated: true)
        removeChild(child: self)
    }
}

extension LearnContentItemCoordinator: LearnContentItemViewControllerDelegate {
    func didTapClose(in viewController: LearnContentItemViewController) {
        rootVC.dismiss(animated: true, completion: nil)
        removeChild(child: self)
    }
    
    func didTapShare(in viewController: LearnContentItemViewController) {
        log("did tap share")
    }
    
    func didTapVideo(with video: LearnContentItem, from view: UIView, in viewController: LearnContentItemViewController) {
        log("did tap video: \(video)")
    }
    
    func didTapArticle(with article: LearnContentItem, from view: UIView, in viewController: LearnContentItemViewController) {
        log("did tap article: \(article)")
    }
}

extension LearnContentItemCoordinator: TopTabBarDelegate {

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
