//
//  BenefitsCoordinator.swift
//  QOT
//
//  Created by karmic on 30/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

final class BenefitsCoordinator: ParentCoordinator {

    internal var rootViewController: SidebarViewController?
    fileprivate let services: Services
    fileprivate let eventTracker: EventTracker
    internal var children = [Coordinator]()
    weak var delegate: ParentCoordinator?
    lazy var presentationManager = PresentationManager()

    init(root: SidebarViewController, services: Services, eventTracker: EventTracker) {
        self.rootViewController = root
        self.services = services
        self.eventTracker = eventTracker
    }

    func start() {
        let benefitsViewController = BenefitsViewController(viewModel: BenefitsViewModel())
        benefitsViewController.delegate = self
        presentationManager.presentationType = .fadeIn
        benefitsViewController.modalPresentationStyle = .custom
        benefitsViewController.transitioningDelegate = presentationManager
        rootViewController?.present(benefitsViewController, animated: true)

        // TODO: Update associatedEntity with realm object when its created.
        eventTracker.track(page: benefitsViewController.pageID, referer: rootViewController?.pageID, associatedEntity: nil)
    }
}

// MARK: - BenefitsViewControllerDelegate

extension BenefitsCoordinator: BenefitsViewControllerDelegate {

    func didTapClose(in viewController: BenefitsViewController) {
        viewController.dismiss(animated: true, completion: nil)
        delegate?.removeChild(child: self)
    }

    func didTapMedia(with item: BenefitItem, from view: UIView, in viewController: BenefitsViewController) {
        log("didTapMedia: \(item)")
    }

    func didTapMore(from view: UIView, in viewController: BenefitsViewController) {
        log("didTapMore")
    }
}
