//
//  SidebarItemCoordinator.swift
//  QOT
//
//  Created by karmic on 28.04.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

final class SidebarItemCoordinator: ParentCoordinator {

    fileprivate let rootViewController: SidebarViewController
    fileprivate let services: Services
    fileprivate let eventTracker: EventTracker
    fileprivate let sidebarContentCategory: ContentCategory
    var children = [Coordinator]()
    lazy var presentationManager = PresentationManager()

    init(
        root: SidebarViewController,
        services: Services,
        eventTracker: EventTracker,
        sidebarContentCategory: ContentCategory) {
            self.rootViewController = root
            self.services = services
            self.eventTracker = eventTracker
            self.sidebarContentCategory = sidebarContentCategory
    }

    func start() {
        let viewModel = SidebarItemViewModel(sidebarContentCategory: sidebarContentCategory)
        let benefitsViewController = SidebarItemViewController(viewModel: viewModel)
        benefitsViewController.delegate = self
        presentationManager.presentationType = .fadeIn
        benefitsViewController.modalPresentationStyle = .custom
        benefitsViewController.transitioningDelegate = presentationManager

        let topTabBarControllerItem = TopTabBarController.Item(
            controllers: [benefitsViewController],
            themes: [.dark],
            titles: [R.string.localized.sidebarTitleBenefits()]
        )

        let topTabBarController = TopTabBarController(
            item: topTabBarControllerItem,
            leftIcon: R.image.ic_minimize(),
            rightIcon: R.image.ic_share()
        )

        topTabBarController.delegate = self
        rootViewController.present(topTabBarController, animated: true)
        // TODO: Update associatedEntity with realm object when its created.
        eventTracker.track(page: benefitsViewController.pageID, referer: rootViewController.pageID, associatedEntity: nil)
    }
}

// MARK: - BenefitsViewControllerDelegate

extension SidebarItemCoordinator: SidebarItemViewControllerDelegate {

    func didTapShare(from view: UIView, in viewController: SidebarItemViewController) {
        print("share")
    }

    func didTapAudio(with item: SidebarItem, from view: UIView, in viewController: SidebarItemViewController) {
        print(didTapAudio)
    }

    func didTapImage(with item: SidebarItem, from view: UIView, in viewController: SidebarItemViewController) {
        print("didTapImage")
    }

    func didTapVideo(with item: SidebarItem, from view: UIView, in viewController: SidebarItemViewController) {
        print("didTapVideo")
    }
}

// MARK: - TopTabBarDelegate

extension SidebarItemCoordinator: TopTabBarDelegate {

    func didSelectLeftButton(sender: TopTabBarController) {
        sender.dismiss(animated: true, completion: nil)
        removeChild(child: self)
    }

    func didSelectRightButton(sender: TopTabBarController) {
        print("didSelectRightButton")
    }

    func didSelectItemAtIndex(index: Int, sender: TopTabBarController) {
        print("didSelectItemAtIndex")
    }
}
