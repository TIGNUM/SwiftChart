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

    var children: [Coordinator] = []

    fileprivate let window: UIWindow
    fileprivate let networkManager: NetworkManager
    fileprivate weak var delegate: LoginCoordinatorDelegate?

    // MARK: - Lifecycle

    init(window: UIWindow, delegate: LoginCoordinatorDelegate, networkManager: NetworkManager) {
        self.window = window
        self.delegate = delegate
        self.networkManager = networkManager
    }

    func start() {
        let loginViewController = LoginViewController(delegate: self)
        let navigationController = UINavigationController(rootViewController: loginViewController)
        navigationController.navigationBar.isHidden = true

        window.setRootViewControllerWithFadeAnimation(navigationController)
        window.makeKeyAndVisible()
    }
}

// MARK: - LoginViewControllerDelegate

extension LoginCoordinator: LoginViewControllerDelegate {

    func didTapLogin(withEmail email: String, password: String, viewController: UIViewController, completion: @escaping (Error?) -> Void) {
        AppDelegate.current.window?.showProgressHUD(type: .fitbit, actionBlock: { [unowned self] in
            let request = AuthenticationRequest(username: email, password: password, deviceID: deviceID)
            self.networkManager.request(request, parser: AuthenticationTokenParser.parse) { [weak self] (result) in
                switch result {
                case .success:
                    completion(nil)
                    self?.delegate?.didLoginSuccessfully()
                case .failure(let error):
                    completion(error)
                    AppDelegate.current.window?.showProgressHUD(type: .loginFailed, actionBlock: {})
                }
            }
        })
    }

    func didTapResetPassword(viewController: UIViewController) {
        let resetPasswordCoordinator = ResetPasswordCoordinator(rootVC: viewController, parentCoordinator: self, networkManager: networkManager)
        startChild(child: resetPasswordCoordinator)
    }

    func checkIfEmailAvailable(email: String, completion: @escaping (Bool) -> Void) {
        let request = EmailCheckRequest(endpoint: .emailCheck, email: email)
        networkManager.request(request, parser: GenericParser.parse) { (result) in
            switch result {
            case .success:
                completion(true)
            case .failure:
                completion(false)
            }
        }
    }
}
