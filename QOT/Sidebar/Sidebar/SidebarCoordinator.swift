//
//  SidebarCoordinator.swift
//  QOT
//
//  Created by karmic on 21/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

final class SidebarCoordinator: ParentCoordinator {

    let rootViewController: UIViewController
    fileprivate let services: Services
    fileprivate let eventTracker: EventTracker
    var children = [Coordinator]()
    lazy var presentationManager = PresentationManager()
    
    init(root: UIViewController, services: Services, eventTracker: EventTracker) {
        self.rootViewController = root
        self.services = services
        self.eventTracker = eventTracker
    }
    
    func start() {
        let viewModel = SidebarViewModel(
            sidebarContentCategories: services.sidebarContentService.categories()
        )
        let sideBarViewController = SidebarViewController(viewModel: viewModel)
        sideBarViewController.delegate = self
        presentationManager.presentationType = .fadeIn
        sideBarViewController.modalPresentationStyle = .custom
        sideBarViewController.transitioningDelegate = presentationManager

        let topTabBarControllerItem = TopTabBarController.Item(
            controllers: [sideBarViewController],
            titles: []
        )

        let topTabBarController = TopTabBarController(
            item: topTabBarControllerItem,
            rightIcon: R.image.ic_close()
        )

        topTabBarController.delegate = self
        rootViewController.present(topTabBarController, animated: true)
    }
}

// MARK: - SettingsViewControllerDelegate

extension SidebarCoordinator: SidebarViewControllerDelegate {

    func didTapLogoutCell(in viewController: SidebarViewController) {
        print("didTapLogoutCell")
    }

    func didTapAddSensorCell(in viewController: SidebarViewController) {
        let coordinator = AddSensorCoordinator(root: viewController, services: services, eventTracker: eventTracker)
        startChild(child: coordinator)
    }

    func didTapSettingsMenuCell(in viewController: SidebarViewController) {
        let coordinator = SettingsMenuCoordinator(root: viewController, services: services, eventTracker: eventTracker)
        startChild(child: coordinator)
    }

    func didTapLibraryCell(in viewController: SidebarViewController) {
        let coordinator = LibraryCoordinator(root: viewController, services: services, eventTracker: eventTracker)
        startChild(child: coordinator)
    }

    func didTapBenefitsCell(from sidebarContentCategory: SidebarContentCategory, in viewController: SidebarViewController) {
        startSidebarItemCoordinator(sidebarContentCategory: sidebarContentCategory, viewController: viewController)
    }

    func didTapAboutCell(from sidebarContentCategory: SidebarContentCategory, in viewController: SidebarViewController) {
        startSidebarItemCoordinator(sidebarContentCategory: sidebarContentCategory, viewController: viewController)
    }

    func didTapPrivacyCell(from sidebarContentCategory: SidebarContentCategory, in viewController: SidebarViewController) {
        startSidebarItemCoordinator(sidebarContentCategory: sidebarContentCategory, viewController: viewController)
    }

    private func startSidebarItemCoordinator(
        sidebarContentCategory: SidebarContentCategory,
        viewController: SidebarViewController) {
            let coordinator = SidebarItemCoordinator(
                root: viewController,
                services: services,
                eventTracker: eventTracker,
                sidebarContentCategory: sidebarContentCategory
            )
            startChild(child: coordinator)
    }
}

// MARK: - TopTabBarDelegate

extension SidebarCoordinator: TopTabBarDelegate {

    func didSelectItemAtIndex(index: Int?, sender: TopTabBarController) {
        print("didSelectItemAtIndex", index, sender)
    }

    func didSelectRightButton(sender: TopTabBarController) {
        sender.dismiss(animated: true, completion: nil)
        removeChild(child: self)
    }

    func didSelectLeftButton(sender: TopTabBarController) {
        print("didSelectLeftButton", sender)
    }
}
