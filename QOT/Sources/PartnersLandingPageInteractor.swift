//
//  PartnersLandingPageInteractor.swift
//  QOT
//
//  Created by karmic on 09.05.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

final class PartnersLandingPageInteractor {

    // MARK: - Properties

    private let worker: PartnersLandingPageWorker
    private let presenter: PartnersLandingPagePresenterInterface
    private let router: PartnersLandingPageRouterInterface

    // MARK: - Init

    init(worker: PartnersLandingPageWorker,
         presenter: PartnersLandingPagePresenterInterface,
         router: PartnersLandingPageRouterInterface) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
    }

    func viewDidLoad() {
        presenter.setup(partnersLandingPage: worker.landingPageDefaults)
    }
}

// MARK: - PartnersLandingPageInteractorInterface

extension PartnersLandingPageInteractor: PartnersLandingPageInteractorInterface {
    func presentPartnersController() {
        router.presentPartnersController()
    }

    func didTapClose() {
        router.dismiss()
    }
}
