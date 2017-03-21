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
    
    internal var rootViewController: UIViewController?
    fileprivate let databaseManager: DatabaseManager?
    fileprivate let eventTracker: EventTracker?
    internal var children = [Coordinator]()
    weak var delegate: ParentCoordinator?
    lazy var presentationManager = PresentationManager()
    
    init(root: UIViewController, databaseManager: DatabaseManager?, eventTracker: EventTracker?) {
        self.rootViewController = root
        self.databaseManager = databaseManager
        self.eventTracker = eventTracker
    }
    
    func start() {
        let vc = SidebarViewController(viewModel: SidebarViewModel())
        vc.delegate = self
        presentationManager.presentationType = .fadeIn
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = presentationManager
        rootViewController?.present(vc, animated: true)
    }
}

// MARK: - SettingsViewControllerDelegate

extension SidebarCoordinator: SidebarViewControllerDelegate {
    
    func didTapClose(in viewController: UIViewController, animated: Bool) {
        viewController.dismiss(animated: animated, completion: nil)
        delegate?.removeChild(child: self)
    }
}
