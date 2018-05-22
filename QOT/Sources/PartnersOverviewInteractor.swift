//
//  PartnersOverviewInteractor.swift
//  QOT
//
//  Created by karmic on 15.05.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import UIKit

final class PartnersOverviewInteractor {

    // MARK: - Properties

    private let worker: PartnersOverviewWorker
    private let presenter: PartnersOverviewPresenterInterface
    private let router: PartnersOverviewRouterInterface

    // MARK: - Init

    init(worker: PartnersOverviewWorker,
        presenter: PartnersOverviewPresenterInterface,
        router: PartnersOverviewRouterInterface) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
    }

    // MARK: - Interactor

    func viewDidLoad() {
        presenter.setup(partners: worker.partners())
    }
}

// MARK: - PartnersOverviewInteractorInterface

extension PartnersOverviewInteractor: PartnersOverviewInteractorInterface {

    func didTapShare(partner: Partners.Partner) {
         router.showShare(partner: partner)
    }

    func editPartner(partner: Partners.Partner) {
        router.showEditPartner(partner: partner)
    }

    func addPartner(partner: Partners.Partner) {
        router.showAddPartner(partner: partner)
    }

    func didTapClose() {
        router.dismiss()
    }
}
