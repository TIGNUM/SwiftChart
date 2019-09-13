//
//  SigningInfoPresenter.swift
//  QOT
//
//  Created by karmic on 28.05.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import UIKit

final class SigningInfoPresenter {

    // MARK: - Properties

    private weak var viewController: SigningInfoViewControllerInterface?

    // MARK: - Init

    init(viewController: SigningInfoViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - SigningInfoInterface

extension SigningInfoPresenter: SigningInfoPresenterInterface {
    func setup() {
        viewController?.setup()
    }

    func presentUnoptimizedAlertView(title: String, message: String, dismissButtonTitle: String) {
        viewController?.presentUnoptimizedAlertView(title: title, message: message, dismissButtonTitle: dismissButtonTitle)
    }
}
