//
//  PartnersOverviewPresenter.swift
//  QOT
//
//  Created by karmic on 15.05.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import UIKit

final class PartnersOverviewPresenter {

    // MARK: - Properties

    private weak var viewController: PartnersOverviewViewControllerInterface?

    // MARK: - Init

    init(viewController: PartnersOverviewViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - PartnersOverviewInterface

extension PartnersOverviewPresenter: PartnersOverviewPresenterInterface {

    func setup(partners: [Partner], partnersLandingPage: PartnersLandingPage?) {
        viewController?.setup(partners: partners, partnersLandingPage: partnersLandingPage)
    }

    func reload(partner: Partner) {
        viewController?.reload(partner: partner)
    }
}
