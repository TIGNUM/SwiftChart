//
//  ConfirmationPresenter.swift
//  QOT
//
//  Created by Javier Sanz Rozalén on 09.05.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class ConfirmationPresenter {

    // MARK: - Properties
    private weak var viewController: ConfirmationViewControllerInterface?

    // MARK: - Init
    init(viewController: ConfirmationViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - ConfirmationInterface
extension ConfirmationPresenter: ConfirmationPresenterInterface {
    func show(_ confirmationModel: Confirmation) {
        viewController?.load(confirmationModel)
    }
}
