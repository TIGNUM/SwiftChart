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
        let categoryTitle = category.title.capitalized
        let selectedContent = category.learnContent.item(at: selectedCategoryIndex)
        let contentTitle = selectedContent.title.capitalized
        let viewModel = LearnContentItemViewModel(contentCollection: selectedContent)
        let fullViewController = LearnContentItemViewController(viewModel: viewModel, categoryTitle: categoryTitle, contentTitle: contentTitle)
        let bulletViewController = LearnContentItemViewController(viewModel: viewModel, categoryTitle: categoryTitle, contentTitle: contentTitle)
        let audioViewController = LearnContentItemViewController(viewModel: viewModel, categoryTitle: categoryTitle, contentTitle: contentTitle)

        let topTabBarControllerItem = TopTabBarController.Item(
            controllers: [fullViewController, bulletViewController, audioViewController],
            themes: [.light, .light, .light],
            titles: [
                R.string.localized.learnContentItemTitleFull(),
                R.string.localized.learnContentItemTitleBullets(),
                R.string.localized.learnContentItemTitleAudio()
            ]
        )

        let topTabBarController = TopTabBarController(
            item: topTabBarControllerItem,
            leftIcon: R.image.ic_minimize(),
            learnHeaderTitle: contentTitle,
            learnHeaderSubTitle: categoryTitle
        )

        fullViewController.serviceDelegate = services
        topTabBarController.modalTransitionStyle = .crossDissolve
        topTabBarController.modalPresentationStyle = .custom
        topTabBarController.delegate = self
        topTabBarController.learnContentItemViewControllerDelegate = fullViewController
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

extension LearnContentItemCoordinator: TopTabBarDelegate {

    func didSelectItemAtIndex(index: Int, sender: TopTabBarController) {
        print(index, sender)
    }

    func didSelectLeftButton(sender: TopTabBarController) {
        sender.dismiss(animated: true, completion: nil)
    }

    func didSelectRightButton(sender: TopTabBarController) {
        print("did select book mark")
    }
}
