//
//  LoginCoordinator.swift
//  QOT
//
//  Created by Moucheg Mouradian on 10/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

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

    func didTapLogin(withEmail email: String, password: String, viewController: UIViewController, completion: @escaping (Error?) -> Void) {
        AppDelegate.current.window?.showProgressHUD(type: .fitbit, actionBlock: { [unowned self] in
            self.networkManager.performAuthenticationRequest(username: email, password: password) { [weak self] (error) in
                completion(error)
                if error == nil {
                    self?.delegate?.didLoginSuccessfully()
                } else {
                    viewController.showAlert(type: .loginFailed)
                }
            }
        })
    }

    func didTapResetPassword(viewController: UIViewController) {
        let resetPasswordCoordinator = ResetPasswordCoordinator(rootVC: viewController, parentCoordinator: self, networkManager: networkManager)
        startChild(child: resetPasswordCoordinator)
    }
}
