//
//  SigningLoginRouter.swift
//  QOT
//
//  Created by karmic on 05.06.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import UIKit

final class SigningLoginRouter {

    // MARK: - Properties

    private let viewController: SigningLoginViewController

    // MARK: - Init

    init(viewController: SigningLoginViewController) {
        self.viewController = viewController
    }
}

// MARK: - SigningLoginRouterInterface

extension SigningLoginRouter: SigningLoginRouterInterface {

    func handleResetPasswordError(_ error: Error) {
        handleLoginError(error)
    }

    func handleLoginError(_ error: Error) {
        viewController.handleError(error)
    }
}

private extension SigningLoginRouter {

    func showAlert(messaggeType: String, viewController: UIViewController) {
        let message = R.string.localized.alertMessageUnknownType(messaggeType)
        let title = R.string.localized.alertTitleCustom()
        viewController.showAlert(type: .custom(title: title, message: message))
    }
}
