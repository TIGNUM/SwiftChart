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
    
    internal var rootViewController: MainMenuViewController?
    fileprivate let databaseManager: DatabaseManager?
    fileprivate let eventTracker: EventTracker?
    internal var children = [Coordinator]()
    weak var delegate: ParentCoordinator?
    lazy var presentationManager = PresentationManager()
    
    init(root: MainMenuViewController, databaseManager: DatabaseManager?, eventTracker: EventTracker?) {
        self.rootViewController = root
        self.databaseManager = databaseManager
        self.eventTracker = eventTracker
    }
    
    func start() {
        let sideBarViewController = SidebarViewController(viewModel: SidebarViewModel())
        sideBarViewController.delegate = self
        presentationManager.presentationType = .fadeIn
        sideBarViewController.modalPresentationStyle = .custom
        sideBarViewController.transitioningDelegate = presentationManager
        rootViewController?.present(sideBarViewController, animated: true)
        eventTracker?.track(page: sideBarViewController.pageID, referer: rootViewController?.pageID, associatedEntity: nil)
    }
}

// MARK: - SettingsViewControllerDelegate

extension SidebarCoordinator: SidebarViewControllerDelegate {
    
    func didTapClose(in viewController: UIViewController, animated: Bool) {
        viewController.dismiss(animated: animated, completion: nil)
        delegate?.removeChild(child: self)
    }
    
    func didTapSettingsCell(in viewController: SidebarViewController) {
        let coordinator = SettingsCoordinator(root: viewController, databaseManager: databaseManager, eventTracker: eventTracker)
        coordinator.delegate = self
        startChild(child: coordinator)
    }    
}
