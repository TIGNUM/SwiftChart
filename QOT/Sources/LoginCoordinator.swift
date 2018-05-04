//
//  LoginCoordinator.swift
//  QOT
//
//  Created by Moucheg Mouradian on 10/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import MBProgressHUD

protocol LoginCoordinatorDelegate: class {

    func loginCoordinatorDidLogin(_ coordinator: LoginCoordinator, loginViewController: LoginViewController?)
}

final class LoginCoordinator: ParentCoordinator {

    // MARK: - Properties

    private let windowManager: WindowManager
    private let networkManager: NetworkManager
    private let syncManager: SyncManager
    private var loginViewController: LoginViewController?
    private weak var delegate: LoginCoordinatorDelegate?
    var children: [Coordinator] = []

    // MARK: - Lifecycle

    init(windowManager: WindowManager,
         delegate: LoginCoordinatorDelegate,
         networkManager: NetworkManager,
         syncManager: SyncManager) {
        self.windowManager = windowManager
        self.delegate = delegate
        self.networkManager = networkManager
        self.syncManager = syncManager
    }

    func start() {
        let loginViewController = LoginViewController(delegate: self)
        let navigationController = UINavigationController(rootViewController: loginViewController)
        navigationController.navigationBar.applyDefaultStyle()
        windowManager.show(navigationController, animated: true, completion: nil)
        self.loginViewController = loginViewController
    }
}

// MARK: - LoginViewControllerDelegate

extension LoginCoordinator: LoginViewControllerDelegate {

    func loginViewController(_ viewController: UIViewController, didTapLoginWithEmail email: String, password: String) {
        let hud = MBProgressHUD.showAdded(to: viewController.view, animated: true, title: nil, message: nil)
        networkManager.performAuthenticationRequest(username: email, password: password) { [weak self] (error) in
            guard let `self` = self else { return }
            if let error = error {
                hud.hide(animated: true)
                self.handleLoginError(error, viewController: viewController)
            } else {
                self.syncManager.downSyncUser { (downSyncError) in
                    if let downSyncError = downSyncError {
                        hud.hide(animated: true)
                        self.handleLoginError(downSyncError, viewController: viewController)
                    } else {
                        hud.hide(animated: true)
                        self.delegate?.loginCoordinatorDidLogin(self, loginViewController: self.loginViewController)
                        self.add3DTouchShortcuts()
                    }
                }
            }
        }
    }

    func loginViewControllerDidTapResetPassword(_ viewController: UIViewController) {
        let resetPasswordCoordinator = ResetPasswordCoordinator(rootVC: viewController, parentCoordinator: self, networkManager: networkManager)
        startChild(child: resetPasswordCoordinator)
    }

    private func handleLoginError(_ error: Error, viewController: UIViewController) {
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
                showAlert(messaggeType: String(format: "data: %@\nError:%@", data.base64EncodedString(),
                                               error.localizedDescription),
                          viewController: viewController)
            case .notFound:
                showAlert(messaggeType: "notFound",
                          viewController: viewController)
            case .unknown(let error, let statusCode):
                showAlert(messaggeType: String(format: "error: %@\nStatusCode:%@", error.localizedDescription, statusCode ?? 0),
                          viewController: viewController)
            case .unknownError:
                viewController.showAlert(type: .unknown)
            }
        } else {
            viewController.showAlert(type: .unknown)
        }
    }
}

private extension LoginCoordinator {

    func showAlert(messaggeType: String, viewController: UIViewController) {
        let message = R.string.localized.alertMessageUnknownType(messaggeType)
        let title = R.string.localized.alertTitleCustom()
        viewController.showAlert(type: .custom(title: title, message: message))
    }

    func add3DTouchShortcuts() {
        UIApplication.shared.shortcutItems?.append(UIMutableApplicationShortcutItem(type: "whats-hot-article",
                                                                                    localizedTitle: "Latest What's Hot Article",
                                                                                    localizedSubtitle: nil,
                                                                                    icon: UIApplicationShortcutIcon(templateImageName: "shortcutItem-whats-hot-article"),
                                                                                    userInfo: ["link": "qot://latest-whats-hot-article"]))
        UIApplication.shared.shortcutItems?.append(UIMutableApplicationShortcutItem(type: "library",
                                                                                    localizedTitle: "Tools",
                                                                                    localizedSubtitle: nil,
                                                                                    icon: UIApplicationShortcutIcon(templateImageName: "shortcutItem-tools"),
                                                                                    userInfo: ["link": "qot://library"]))
        UIApplication.shared.shortcutItems?.append(UIMutableApplicationShortcutItem(type: "me-universe",
                                                                                    localizedTitle: "Review My Data",
                                                                                    localizedSubtitle: nil,
                                                                                    icon: UIApplicationShortcutIcon(templateImageName: "shortcutItem-my-data"),
                                                                                    userInfo: ["link": "qot://me-universe"]))
        UIApplication.shared.shortcutItems?.append(UIMutableApplicationShortcutItem(type: "prepare",
                                                                                    localizedTitle: "Prepare for an event",
                                                                                    localizedSubtitle: nil,
                                                                                    icon: UIApplicationShortcutIcon(templateImageName: "shortcutItem-prepare"),
                                                                                    userInfo: ["link": "qot://prepare"]))
    }
}
