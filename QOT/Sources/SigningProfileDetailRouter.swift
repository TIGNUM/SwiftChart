//
//  SigningProfileDetailRouter.swift
//  QOT
//
//  Created by karmic on 12.06.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import UIKit

final class SigningProfileDetailRouter {

    // MARK: - Properties

    private let viewController: SigningProfileDetailViewController

    // MARK: - Init

    init(viewController: SigningProfileDetailViewController) {
        self.viewController = viewController
    }
}

// MARK: - SigningProfileDetailRouterInterface

extension SigningProfileDetailRouter: SigningProfileDetailRouterInterface {

    func handleError(_ error: Error?) {
        viewController.handleError(error)
    }

    func showAlert(message: String) {
        let messageType = R.string.localized.alertMessageUnknownType(message)
        let title = R.string.localized.alertTitleCustom()
        viewController.showAlert(type: .custom(title: title, message: messageType))
    }

    func showTermsOfUse() {
        // FIXME: THIS VIEW CONTROLLER IS NOT USED
    }

    func showPrivacyPolicy() {
        // FIXME: THIS VIEW CONTROLLER IS NOT USED
    }

    func add3DTouchShortcuts() {
        viewController.add3DTouchShortcuts()
    }
}
