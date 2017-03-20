//
//  SettingsCoordinator.swift
//  QOT
//
//  Created by karmic on 20/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

final class SettingsCoordinator             : ParentCoordinator {
    
    internal var rootViewController         : UIViewController?
    fileprivate let databaseManager         : DatabaseManager?
    fileprivate let eventTracker            : EventTracker?
    internal var children                   = [Coordinator]()
    
    init(root: UIViewController, databaseManager: DatabaseManager?, eventTracker: EventTracker?) {
        self.rootViewController = root
        self.databaseManager = databaseManager
        self.eventTracker = eventTracker
    }
    
    func start() {
        let vc = SettingsViewController(viewModel: SettingsViewModel())
        vc.delegate = self
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .custom
        self.rootViewController?.present(vc, animated: true)
    }
}

// MARK: - SettingsViewControllerDelegate

extension SettingsCoordinator               : SettingsViewControllerDelegate {
    
    func didTapSettingsViewController(_ viewController: UIViewController) {
        let coordinator = SettingsCoordinator(root: viewController, databaseManager: self.databaseManager, eventTracker: self.eventTracker)
        coordinator.start()
        self.children.append(coordinator)
    }
}
