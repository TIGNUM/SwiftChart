//
//  SigningEmailPresenter.swift
//  QOT
//
//  Created by karmic on 29.05.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import UIKit

final class SigningEmailPresenter {

    // MARK: - Properties

    private weak var viewController: SigningEmailViewControllerInterface?

    // MARK: - Init

    init(viewController: SigningEmailViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - SigningEmailInterface

extension SigningEmailPresenter: SigningEmailPresenterInterface {

    func endEditing() {
        viewController?.endEditing()
    }

    func hideErrorMessage() {
        viewController?.hideErrorMessage()
    }

    func activateButton(_ active: Bool) {
        viewController?.activateButton(active)
    }

    func reload(errorMessage: String?, buttonActive: Bool) {
        viewController?.reload(errorMessage: errorMessage, buttonActive: buttonActive)
    }

    func setup() {
        viewController?.setup()
    }
}
