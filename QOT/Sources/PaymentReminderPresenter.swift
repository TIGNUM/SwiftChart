//
//  PaymentReminderPresenter.swift
//  
//
//  Created by Anais Plancoulaine on 17.06.19.
//

import UIKit

final class PaymentReminderPresenter {

    // MARK: - Properties

    private weak var viewController: PaymentReminderViewControllerInterface?

    // MARK: - Init

    init(viewController: PaymentReminderViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - PaymentReminderInterface

extension PaymentReminderPresenter: PaymentReminderPresenterInterface {

    func setupView() {
        viewController?.setupView()
    }

    func present(for paymentSection: PaymentModel) {
        viewController?.setup(for: paymentSection)
    }
}
