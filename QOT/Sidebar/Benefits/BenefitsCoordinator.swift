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

    fileprivate let rootViewController: SidebarViewController
    fileprivate let services: Services
    fileprivate let eventTracker: EventTracker
    var children = [Coordinator]()
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

        let topTabBarController = TopTabBarController(
            items: [benefitsViewController.topTabBarItem],
            selectedIndex: 0,
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

extension BenefitsCoordinator: BenefitsViewControllerDelegate {

    func didTapMedia(with item: BenefitItem, from view: UIView, in viewController: BenefitsViewController) {
        log("didTapMedia: \(item)")
    }

    func didTapMore(from view: UIView, in viewController: BenefitsViewController) {
        log("didTapMore")
    }
}

// MARK: - TopTabBarDelegate

extension BenefitsCoordinator: TopTabBarDelegate {

    func didSelectLeftButton(sender: TopTabBarController) {
        sender.dismiss(animated: true, completion: nil)
        removeChild(child: self)
    }

    func didSelectRightButton(sender: TopTabBarController) {
        print("didSelectRightButton")
    }

    func didSelectItemAtIndex(index: Int?, sender: TopTabBarController) {
        print("didSelectItemAtIndex")
    }
}
