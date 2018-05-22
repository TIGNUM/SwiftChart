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
        let partner = Partners.Partner(localID: "", name: nil, surname: nil, relationship: nil, email: nil, imageURL: nil)
        let configurator = PartnerEditConfigurator.make(partnerToEdit: partner)
        let partnersController = PartnerEditViewController(configure: configurator)
        partnersController.title = R.string.localized.meSectorMyWhyPartnersTitle().uppercased()
        let navController = UINavigationController(rootViewController: partnersController)
        navController.navigationBar.applyDefaultStyle()
        navController.modalPresentationStyle = .custom
        navController.transitioningDelegate = partnersController.transitioningDelegate
        viewController.presentPartnersController(navigationController: navController)
    }
}
