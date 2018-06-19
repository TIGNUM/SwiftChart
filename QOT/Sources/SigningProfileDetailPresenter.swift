//
//  SigningProfileDetailPresenter.swift
//  QOT
//
//  Created by karmic on 12.06.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import UIKit

final class SigningProfileDetailPresenter {

    // MARK: - Properties

    private weak var viewController: SigningProfileDetailViewControllerInterface?

    // MARK: - Init

    init(viewController: SigningProfileDetailViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - SigningProfileDetailInterface

extension SigningProfileDetailPresenter: SigningProfileDetailPresenterInterface {

    func setup() {
        viewController?.setup()
    }

    func activateButton(_ active: Bool) {
        viewController?.activateButton(active)
    }

    func endEditing() {
        viewController?.endEditing()
    }
}
