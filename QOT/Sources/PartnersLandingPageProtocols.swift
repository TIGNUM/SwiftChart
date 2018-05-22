//
//  PartnersLandingPageProtocols.swift
//  QOT
//
//  Created by karmic on 09.05.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

protocol PartnersLandingPageViewControllerInterface: class {
    func dismiss()
    func setup(partnersLandingPage: PartnersLandingPage)
    func presentPartnersController(navigationController: UINavigationController)
}

protocol PartnersLandingPagePresenterInterface {
    func setup(partnersLandingPage: PartnersLandingPage)
}

protocol PartnersLandingPageInteractorInterface: Interactor {
    func didTapClose()
    func presentPartnersController()
}

protocol PartnersLandingPageRouterInterface {
    func dismiss()
    func presentPartnersController()
}
