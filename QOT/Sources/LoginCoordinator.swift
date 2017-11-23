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

    func loginCoordinatorDidLogin(_ coordinator: LoginCoordinator)
}

final class LoginCoordinator: ParentCoordinator {

    // MARK: - Properties

    private let windowManager: WindowManager
    private let networkManager: NetworkManager
    private let syncManager: SyncManager
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
                        self.delegate?.loginCoordinatorDidLogin(self)
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
        if let networkError = error as? NetworkError {
            switch networkError.type {
            case .unauthenticated:
                viewController.showAlert(type: .loginFailed)
            case .noNetworkConnection:
                viewController.showAlert(type: .noNetworkConnection)
            default:
                viewController.showAlert(type: .unknown)
            }
        } else {
            viewController.showAlert(type: .unknown)
        }
    }
}
