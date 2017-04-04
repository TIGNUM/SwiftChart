//
//  SettingsCoordinator.swift
//  QOT
//
//  Created by karmic on 20/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

final class SettingsCoordinator: ParentCoordinator {
    
    internal var rootViewController: SidebarViewController?
    fileprivate let services: Services?
    fileprivate let eventTracker: EventTracker?
    internal var children = [Coordinator]()
    weak var delegate: ParentCoordinator?
    lazy var presentationManager = PresentationManager()
    
    init(root: SidebarViewController, services: Services?, eventTracker: EventTracker?) {
        self.rootViewController = root
        self.services = services
        self.eventTracker = eventTracker
    }

    func start() {
        let settingsViewController = SettingsViewController(viewModel: SettingsViewModel())
        settingsViewController.delegate = self
        presentationManager.presentationType = .fadeIn
        settingsViewController.modalPresentationStyle = .custom
        settingsViewController.transitioningDelegate = presentationManager
        rootViewController?.present(settingsViewController, animated: true)
        
        // TODO: Update associatedEntity with realm object when its created.
        eventTracker?.track(page: settingsViewController.pageID, referer: rootViewController?.pageID, associatedEntity: nil)
    }
}

// MARK: - SettingsViewControllerDelegate

extension SettingsCoordinator: SettingsViewControllerDelegate {
    
    func didTapClose(in viewController: UIViewController, animated: Bool) {
        viewController.dismiss(animated: animated, completion: nil)
        delegate?.removeChild(child: self)
    }
}
