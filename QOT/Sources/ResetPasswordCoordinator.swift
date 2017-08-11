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
    fileprivate var topTabBarController: UINavigationController!

    // MARK: - Lifecycle

    init(rootVC: UIViewController, parentCoordinator: ParentCoordinator, networkManager: NetworkManager) {
        self.rootViewController = rootVC
        self.networkManager = networkManager
        self.parentCoordinator = parentCoordinator

        let leftButton = UIBarButtonItem(withImage: R.image.ic_back(), tintColor: .clear)
        let resetPasswordViewController = ResetPasswordViewController(delegate: self)
        topTabBarController = UINavigationController(withPages: [resetPasswordViewController], topBarDelegate: self, leftButton: leftButton)
    }

    func start() {
        rootViewController.presentRightToLeft(controller: topTabBarController)
    }
}

// MARK: - TopNavigationBarDelegate

extension ResetPasswordCoordinator: TopNavigationBarDelegate {

    func topNavigationBar(_ navigationBar: TopNavigationBar, leftButtonPressed button: UIBarButtonItem) {
        topTabBarController.dismissLeftToRight()
    }

    func topNavigationBar(_ navigationBar: TopNavigationBar, middleButtonPressed button: UIButton, withIndex index: Int, ofTotal total: Int) {}

    func topNavigationBar(_ navigationBar: TopNavigationBar, rightButtonPressed button: UIBarButtonItem) {}
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
        topTabBarController.dismissLeftToRight()
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
