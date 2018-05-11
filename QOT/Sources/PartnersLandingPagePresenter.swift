//
//  PartnersLandingPagePresenter.swift
//  QOT
//
//  Created by karmic on 09.05.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

final class PartnersLandingPagePresenter {

    // MARK: - Properties

    private let viewController: PartnersLandingPageViewControllerInterface

    // MARK: - Init

    init(viewController: PartnersLandingPageViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - PartnersLandingPagePresenterInterface

extension PartnersLandingPagePresenter: PartnersLandingPagePresenterInterface {

    func setup(partnersLandingPage: PartnersLandingPage) {
        viewController.setup(partnersLandingPage: partnersLandingPage)
    }
}
