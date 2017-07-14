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

    var children: [Coordinator] = []

    fileprivate let rootViewController: UIViewController
    fileprivate let networkManager: NetworkManager
    fileprivate let parentCoordinator: ParentCoordinator

    // MARK: - Lifecycle

    init(rootVC: UIViewController, parentCoordinator: ParentCoordinator, networkManager: NetworkManager) {
        self.rootViewController = rootVC
        self.networkManager = networkManager
        self.parentCoordinator = parentCoordinator
    }

    func start() {
        let resetPasswordViewController = ResetPasswordViewController(delegate: self)

        rootViewController.present(resetPasswordViewController, animated: true, completion: nil)
    }
}

// MARK: - LoginDelegate

extension ResetPasswordCoordinator: ResetPasswordViewControllerDelegate {
    func didTapResetPassword(withUsername username: String, completion: @escaping (NetworkError?) -> Void) {
        AppDelegate.current.window?.showProgressHUD(type: .fitbit, actionBlock: { [unowned self] in
            let token = ["email": username]
            do {
                let body = try token.toJSON().serialize()
                let request = ResetPasswordRequest(endpoint: .resetPassword, body: body)
                self.networkManager.request(request, parser: GenericParser.parse) { (result) in
                    switch result {
                    case .success:
                        completion(nil)
                    case .failure(let error):
                        completion(error)
                    }
                }
            } catch {
                return
            }
        })
    }

    func didTapBack(viewController: UIViewController) {
        viewController.dismiss(animated: true, completion: nil)
        parentCoordinator.removeChild(child: self)
    }

    func checkIfEmailAvailable(email: String, completion: @escaping (Bool) -> Void) {
        let request = EmailCheckRequest(endpoint: .emailCheck, email: email)
        networkManager.request(request, parser: GenericParser.parse) { (result) in
            switch result {
            case .success:
                print("Check success")
                completion(true)
            case .failure:
                print("Check failure")
                completion(false)
            }
        }
    }
}
