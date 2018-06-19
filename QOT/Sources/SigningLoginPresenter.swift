//
//  SigningLoginPresenter.swift
//  QOT
//
//  Created by karmic on 05.06.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import UIKit

final class SigningLoginPresenter {

    // MARK: - Properties

    private weak var viewController: SigningLoginViewControllerInterface?

    // MARK: - Init

    init(viewController: SigningLoginViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - SigningLoginInterface

extension SigningLoginPresenter: SigningLoginPresenterInterface {

    func didResendPassword() {
        viewController?.didResendPassword()
    }

    func reload(errorMessage: String?, buttonActive: Bool) {
        viewController?.reload(errorMessage: errorMessage, buttonActive: buttonActive)
    }

    func activateButton(_ active: Bool) {
        viewController?.activateButton(active)
    }

    func endEditing() {
        viewController?.endEditing()
    }

    func setup() {
        viewController?.setup()
    }
}
