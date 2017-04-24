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
    
    fileprivate let rootViewController: UIViewController
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
        let sideBarViewController = SidebarViewController(viewModel: SidebarViewModel())
        sideBarViewController.delegate = self
        presentationManager.presentationType = .fadeIn
        sideBarViewController.modalPresentationStyle = .custom
        sideBarViewController.transitioningDelegate = presentationManager

        let topTabBarController = TopTabBarController(
            items: [sideBarViewController.topTabBarItem],
            selectedIndex: 0,
            rightIcon: R.image.ic_close()
        )

        topTabBarController.delegate = self
        rootViewController.present(topTabBarController, animated: true)
    }
}

// MARK: - SettingsViewControllerDelegate

extension SidebarCoordinator: SidebarViewControllerDelegate {

    func didTapSettingsCell(in viewController: SidebarViewController) {
        let coordinator = SettingsCoordinator(root: viewController, services: services, eventTracker: eventTracker)
        startCoordinator(coordinator: coordinator)
    }

    func didTapLibraryCell(in viewController: SidebarViewController) {
        let coordinator = LibraryCoordinator(root: viewController, services: services, eventTracker: eventTracker)
        startCoordinator(coordinator: coordinator)
    }

    func didTapBenefitsCell(in viewController: SidebarViewController) {
        let coordinator = BenefitsCoordinator(root: viewController, services: services, eventTracker: eventTracker)        
        startCoordinator(coordinator: coordinator)
    }

    private func startCoordinator(coordinator: ParentCoordinator) {
        coordinator.start()
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
