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
    
    internal var rootViewController: UIViewController?
    fileprivate let databaseManager: DatabaseManager?
    fileprivate let eventTracker: EventTracker?
    internal var children = [Coordinator]()
    weak var delegate: ParentCoordinator?
    weak var presentationManager = PresentationManager()
    
    init(root: UIViewController, databaseManager: DatabaseManager?, eventTracker: EventTracker?) {
        self.rootViewController = root
        self.databaseManager = databaseManager
        self.eventTracker = eventTracker
    }
    
    func start() {
        let vc = SettingsViewController(viewModel: SettingsViewModel())
        vc.delegate = self
        vc.modalPresentationStyle = .custom
        presentationManager?.presentationType = .fade
        vc.transitioningDelegate = presentationManager
        rootViewController?.present(vc, animated: true)
    }
}

// MARK: - SettingsViewControllerDelegate

extension SettingsCoordinator: SettingsViewControllerDelegate {
    
    func didTapClose(in viewController: UIViewController, animated: Bool) {
        viewController.dismiss(animated: animated, completion: nil)
        delegate?.removeChild(child: self)
    }
}
