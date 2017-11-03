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

    func didLoginSuccessfully()
}

final class LoginCoordinator: ParentCoordinator {

    // MARK: - Properties

    fileprivate let windowManager: WindowManager
    fileprivate let networkManager: NetworkManager
    fileprivate weak var delegate: LoginCoordinatorDelegate?
    var children: [Coordinator] = []

    // MARK: - Lifecycle

    init(windowManager: WindowManager, delegate: LoginCoordinatorDelegate, networkManager: NetworkManager) {
        self.windowManager = windowManager
        self.delegate = delegate
        self.networkManager = networkManager
    }

    func start() {
        let loginViewController = LoginViewController(delegate: self)
        let navigationController = UINavigationController(rootViewController: loginViewController)
        let navigationBar = navigationController.navigationBar
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        windowManager.setRootViewController(navigationController, atLevel: .normal, animated: true, completion: nil)
    }
}

// MARK: - LoginViewControllerDelegate

extension LoginCoordinator: LoginViewControllerDelegate {

    func loginViewController(_ viewController: UIViewController, didTapLoginWithEmail email: String, password: String) {
        guard let window = AppDelegate.current.window else {
            return
        }
        let progressHUD = MBProgressHUD.showAdded(to: window, animated: true)
        networkManager.performAuthenticationRequest(username: email, password: password) { error in
            progressHUD.hide(animated: true)
            guard error == nil else {
                viewController.showAlert(type: .loginFailed)
                return
            }
            self.delegate?.didLoginSuccessfully()
        }
    }

    func loginViewControllerDidTapResetPassword(_ viewController: UIViewController) {
        let resetPasswordCoordinator = ResetPasswordCoordinator(rootVC: viewController, parentCoordinator: self, networkManager: networkManager)
        startChild(child: resetPasswordCoordinator)
    }
}
