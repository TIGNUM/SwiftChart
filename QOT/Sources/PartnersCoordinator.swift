//
//  PartnersCoordinator.swift
//  QOT
//
//  Created by karmic on 19.04.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import UIKit

final class PartnersCoordinator: NSObject, ParentCoordinator {

    // MARK: - Properties

    private let services: Services
    private let rootViewController: UIViewController
    private let transitioningDelegate: UIViewControllerTransitioningDelegate // swiftlint:disable:this weak_delegate
    var children: [Coordinator] = []

    // MARK: - Life Cycle

    init(root: UIViewController, services: Services,
         transitioningDelegate: UIViewControllerTransitioningDelegate,
         selectedIndex: Index,
         permissionsManager: PermissionsManager) {
        self.rootViewController = root
        self.services = services
        self.transitioningDelegate = transitioningDelegate

        super.init()
    }

    func start() {
        startPartnersViewController()
    }
}

// MARK: - Private

private extension PartnersCoordinator {

    func startPartnersViewController() {
        let configurator = PartnersOverviewConfigurator.make()
        let viewController = PartnersOverviewViewController(configure: configurator)
        presentController(viewController)
    }

    func presentController(_ partnersAnimationViewController: PartnersAnimationViewController) {
        partnersAnimationViewController.title = R.string.localized.meSectorMyWhyPartnersTitle().uppercased()
        let navController = UINavigationController(rootViewController: partnersAnimationViewController)
        navController.navigationBar.applyDefaultStyle()
        navController.modalPresentationStyle = .custom
        navController.transitioningDelegate = transitioningDelegate
        rootViewController.present(navController, animated: true, completion: nil)
    }
}
