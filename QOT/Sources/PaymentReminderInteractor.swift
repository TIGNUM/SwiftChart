//
//  PaymentReminderInteractor.swift
//  QOT
//
//  Created by Anais Plancoulaine on 17.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class PaymentReminderInteractor {

    // MARK: - Properties

    private let worker: PaymentReminderWorker
    private let presenter: PaymentReminderPresenterInterface
    private let router: PaymentReminderRouterInterface

    // MARK: - Init

    init(worker: PaymentReminderWorker,
         presenter: PaymentReminderPresenterInterface,
         router: PaymentReminderRouterInterface) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
    }

    // MARK: - Interactor

    func viewDidLoad() {
        presenter.setupView()
        presenter.present(for: worker.paymentSections())
    }
}

// MARK: - PaymentReminderInteractorInterface

extension PaymentReminderInteractor: PaymentReminderInteractorInterface {
    var isExpired: Bool {
        return worker.expired
    }

    func didTapSwitchAccounts() {
        router.showLogoutDialog()
    }
}
