//
//  SigningDigitPresenter.swift
//  QOT
//
//  Created by karmic on 07.06.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import UIKit

final class SigningDigitPresenter {

    // MARK: - Properties

    private weak var viewController: SigningDigitViewControllerInterface?

    // MARK: - Init

    init(viewController: SigningDigitViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - SigningDigitInterface

extension SigningDigitPresenter: SigningDigitPresenterInterface {

    func setup(code: String?) {
        viewController?.setup(code: code)
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
}
