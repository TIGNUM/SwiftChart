//
//  PaymentReminderInterface.swift
//  QOT
//
//  Created by Anais Plancoulaine on 17.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

protocol PaymentReminderViewControllerInterface: class {
    func setupView()
     func setup(for paymentSection: PaymentModel)
}

protocol PaymentReminderPresenterInterface {
    func setupView()
    func present(for paymentSection: PaymentModel)
}

protocol PaymentReminderInteractorInterface: Interactor {
    func didTapSwitchAccounts()
    var isExpired: Bool { get }
}

protocol PaymentReminderRouterInterface {
    func dismiss()
    func showLogoutDialog()
}
