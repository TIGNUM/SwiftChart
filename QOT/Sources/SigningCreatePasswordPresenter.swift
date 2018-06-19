//
//  SigningCreatePasswordPresenter.swift
//  QOT
//
//  Created by karmic on 07.06.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import UIKit

final class SigningCreatePasswordPresenter {

    // MARK: - Properties

    private weak var viewController: SigningCreatePasswordViewControllerInterface?

    // MARK: - Init

    init(viewController: SigningCreatePasswordViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - SigningCreatePasswordInterface

extension SigningCreatePasswordPresenter: SigningCreatePasswordPresenterInterface {

    func setup() {
        viewController?.setup()
    }

    func reload(errorMessage: String?, buttonActive: Bool) {
        viewController?.reload(errorMessage: errorMessage, buttonActive: buttonActive)
    }

    func hideErrorMessage() {
        viewController?.hideErrorMessage()
    }

    func activateButton(_ active: Bool) {
        viewController?.activateButton(active)
    }

    func endEditing() {
        viewController?.endEditing()
    }
}
