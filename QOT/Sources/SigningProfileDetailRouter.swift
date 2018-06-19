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
        log("Failed to login with error: \(error?.localizedDescription))", level: .error)
        if let networkError = error as? NetworkError {
            switch networkError.type {
            case .unauthenticated: viewController.showAlert(type: .loginFailed)
            case .noNetworkConnection: viewController.showAlert(type: .noNetworkConnection)
            case .cancelled: showAlert(messaggeType: "cancelled", viewController: viewController)
            case .failedToParseData(let data, let error):
                showAlert(messaggeType: String(format: "data: %@\nError:%@",
                                               data.base64EncodedString(),
                                               error.localizedDescription),
                          viewController: viewController)
            case .notFound: showAlert(messaggeType: "notFound", viewController: viewController)
            case .unknown(let error, let statusCode):
                showAlert(messaggeType: String(format: "error: %@\nStatusCode:%@",
                                               error.localizedDescription, statusCode ?? 0),
                          viewController: viewController)
            case .unknownError:
                viewController.showAlert(type: .unknown)
            }
        } else {
            viewController.showAlert(type: .unknown)
        }
    }

    func showAlert(message: String) {
        let messageType = R.string.localized.alertMessageUnknownType(message)
        let title = R.string.localized.alertTitleCustom()
        viewController.showAlert(type: .custom(title: title, message: messageType))
    }

    func showAlert(messaggeType: String, viewController: UIViewController) {
        let message = R.string.localized.alertMessageUnknownType(messaggeType)
        let title = R.string.localized.alertTitleCustom()
        viewController.showAlert(type: .custom(title: title, message: message))
    }

    func showTermsOfUse() {
        AppDelegate.current.appCoordinator.presentContentItemSettings(contentID: 100102, controller: viewController)
    }

    func showPrivacyPolicy() {
        AppDelegate.current.appCoordinator.presentContentItemSettings(contentID: 100163, controller: viewController)
    }    
}
