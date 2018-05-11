//
//  PartnersLandingPageRouter.swift
//  QOT
//
//  Created by karmic on 09.05.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

final class PartnersLandingPageRouter {

    // MARK: - Properties

    private let viewController: PartnersLandingPageViewControllerInterface

    // MARK: - Init

    init(viewController: PartnersLandingPageViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - PartnersLandingPageRouterInterface

extension PartnersLandingPageRouter: PartnersLandingPageRouterInterface {

    func dismiss() {
        viewController.dismiss()
    }

    func presentPartnersController() {
        let configurator = PartnersConfigurator.make()
        let viewController = PartnersViewController(configure: configurator)
        viewController.title = R.string.localized.meSectorMyWhyPartnersTitle().uppercased()
        let navController = UINavigationController(rootViewController: viewController)
        navController.navigationBar.applyDefaultStyle()
        navController.modalPresentationStyle = .custom
        navController.transitioningDelegate = viewController.transitioningDelegate
        viewController.present(navController, animated: true, completion: nil)
    }
}
