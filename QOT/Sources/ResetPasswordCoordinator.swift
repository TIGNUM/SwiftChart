//
//  ResetPasswordCoordinator.swift
//  QOT
//
//  Created by Moucheg Mouradian on 10/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class ResetPasswordCoordinator: ParentCoordinator {

    // MARK: - Properties

    fileprivate let networkManager: NetworkManager
    fileprivate let parentCoordinator: ParentCoordinator
    fileprivate let resetPasswordViewController: ResetPasswordViewController!
    fileprivate let rootViewController: UIViewController
    var children: [Coordinator] = []

    // MARK: - Lifecycle

    init(rootVC: UIViewController, parentCoordinator: ParentCoordinator, networkManager: NetworkManager) {
        self.rootViewController = rootVC
        self.networkManager = networkManager
        self.parentCoordinator = parentCoordinator
        resetPasswordViewController = ResetPasswordViewController()
        resetPasswordViewController.delegate = self
    }

    func start() {
        rootViewController.pushToStart(childViewController: resetPasswordViewController)
    }
}

// MARK: - LoginDelegate

extension ResetPasswordCoordinator: ResetPasswordViewControllerDelegate {
    
    func didTapResetPassword(withUsername username: String, completion: @escaping (NetworkError?) -> Void) {
        AppDelegate.current.window?.showProgressHUD(type: .fitbit) { [networkManager] in
            networkManager.performResetPasswordRequest(username: username, completion: completion)
        }
    }
}
