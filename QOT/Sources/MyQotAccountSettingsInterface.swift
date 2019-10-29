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
}

protocol MyQotAccountSettingsPresenterInterface {
    func setupView()
    func showLogoutAlert()
}

protocol MyQotAccountSettingsInteractorInterface: Interactor {
    var accountSettingsText: String { get }
    var contactText: String { get }
    var emailText: String { get }
    var dateOfBirthText: String { get }
    var companyText: String { get }
    var personalDataText: String { get }
    var accountText: String { get }
    var changePasswordText: String { get }
    var protectYourAccountText: String { get }
    var logoutQotText: String { get }
    var withoutDeletingAccountText: String { get }
    var logoutQOTKey: String { get }
    func userProfile(_ completion: @escaping (UserProfileModel?) -> Void)
    func showLogoutAlert()
    func logout()
    func presentEditAccountSettings()
}

protocol MyQotAccountSettingsRouterInterface {
    func showAlert(_ type: AlertType)
    func showProgressHUD()
    func hideProgressHUD()
    func presentEditAccountSettings()
}
