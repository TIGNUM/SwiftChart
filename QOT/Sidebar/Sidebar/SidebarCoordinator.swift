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
    
    internal var rootViewController: TopTabBarController?
    fileprivate let services: Services
    fileprivate let eventTracker: EventTracker
    internal var children = [Coordinator]()
    lazy var presentationManager = PresentationManager()
    
    init(root: TopTabBarController, services: Services, eventTracker: EventTracker) {
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
        rootViewController?.present(sideBarViewController, animated: true)
    }
}

// MARK: - SettingsViewControllerDelegate

extension SidebarCoordinator: SidebarViewControllerDelegate {
    
    func didTapClose(in viewController: UIViewController, animated: Bool) {
        viewController.dismiss(animated: animated, completion: nil)
        removeChild(child: self)
    }
    
    func didTapSettingsCell(in viewController: SidebarViewController) {
        let coordinator = SettingsCoordinator(root: viewController, services: services, eventTracker: eventTracker)
        startChild(child: coordinator)
    }

    func didTapLibraryCell(in viewController: SidebarViewController) {
        let coordinator = LibraryCoordinator(root: viewController, services: services, eventTracker: eventTracker)
        startChild(child: coordinator)
    }

    func didTapBenefitsCell(in viewController: SidebarViewController) {
        let coordinator = BenefitsCoordinator(root: viewController, services: services, eventTracker: eventTracker)        
        startChild(child: coordinator)
    }
}
