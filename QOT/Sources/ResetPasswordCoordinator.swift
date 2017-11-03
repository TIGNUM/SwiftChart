//
//  ResetPasswordCoordinator.swift
//  QOT
//
//  Created by Moucheg Mouradian on 10/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import MBProgressHUD

final class ResetPasswordCoordinator: ParentCoordinator {

    // MARK: - Properties

    private let networkManager: NetworkManager
    private let parentCoordinator: ParentCoordinator
    private let resetPasswordViewController: ResetPasswordViewController!
    private let rootViewController: UIViewController
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
        guard let window = AppDelegate.current.window else {
            return
        }
        let progressHUD = MBProgressHUD.showAdded(to: window, animated: true)
        networkManager.performResetPasswordRequest(username: username, completion: { error in
            progressHUD.hide(animated: true)
            completion(error)
        })
    }
}
