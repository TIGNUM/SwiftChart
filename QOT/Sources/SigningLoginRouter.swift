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
        log("Failed to login with error: \(error.localizedDescription))", level: .error)
        if let networkError = error as? NetworkError {
            switch networkError.type {
            case .unauthenticated:
                viewController.showAlert(type: .loginFailed)
            case .noNetworkConnection:
                viewController.showAlert(type: .noNetworkConnection)
            case .cancelled:
                showAlert(messaggeType: "cancelled",
                          viewController: viewController)
            case .failedToParseData(let data, let error):
                showAlert(messaggeType: String(format: "data: %@\nError: %@",
                                               data.base64EncodedString(),
                                               error.localizedDescription),
                          viewController: viewController)
            case .notFound:
                showAlert(messaggeType: "notFound",
                          viewController: viewController)
            case .unknown(let error, let statusCode):
                showAlert(messaggeType: String(format: "error: %@\nStatusCode: %d",
                                               error.localizedDescription,
                                               statusCode ?? 0),
                          viewController: viewController)
            case .unknownError:
                viewController.showAlert(type: .unknown)
            }
        } else {
            viewController.showAlert(type: .unknown)
        }
    }
}

private extension SigningLoginRouter {

    func showAlert(messaggeType: String, viewController: UIViewController) {
        let message = R.string.localized.alertMessageUnknownType(messaggeType)
        let title = R.string.localized.alertTitleCustom()
        viewController.showAlert(type: .custom(title: title, message: message))
    }
}
