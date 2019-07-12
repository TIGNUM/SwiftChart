//
//  MyQotAccountSettingsInterface.swift
//  QOT
//
//  Created by Ashish Maheshwari on 08.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

protocol MyQotAccountSettingsViewControllerInterface: class {
    func setupView()
    func showLogoutAlert()
    func showResetPasswordAlert()
}

protocol MyQotAccountSettingsPresenterInterface {
    func setupView()
    func showLogoutAlert()
    func showResetPasswordAlert()
}

protocol MyQotAccountSettingsInteractorInterface: Interactor {
    func accountSettingsText(_ completion: @escaping(String) -> Void)
    func contactText(_ completion: @escaping(String) -> Void)
    func emailText(_ completion: @escaping(String) -> Void)
    func phoneText(_ completion: @escaping(String) -> Void)
    func personalDataText(_ completion: @escaping(String) -> Void)
    func heightText(_ completion: @escaping(String) -> Void)
    func weightText(_ completion: @escaping(String) -> Void)
    func accountText(_ completion: @escaping(String) -> Void)
    func changePasswordText(_ completion: @escaping(String) -> Void)
    func protectYourAccountText(_ completion: @escaping(String) -> Void)
    func logoutQotText(_ completion: @escaping(String) -> Void)
    func withoutDeletingAccountText(_ completion: @escaping(String) -> Void)
    func userProfile(_ completion: @escaping (UserProfileModel?) -> Void)
    func showLogoutAlert()
    func showResetPasswordAlert()
    func logout()
    func resetPassword()
    func presentEditAccountSettings()
}

protocol MyQotAccountSettingsRouterInterface {
    func showAlert(_ type: AlertType)
    func showProgressHUD()
    func hideProgressHUD()
    func presentEditAccountSettings()
}
