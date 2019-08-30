//
//  MyQotAccountSettingsInteractor.swift
//  QOT
//
//  Created by Ashish Maheshwari on 08.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class MyQotAccountSettingsInteractor {

    // MARK: - Properties
    private let worker: MyQotAccountSettingsWorker
    private let presenter: MyQotAccountSettingsPresenterInterface
    private let router: MyQotAccountSettingsRouterInterface

    // MARK: - Init
    init(worker: MyQotAccountSettingsWorker,
         presenter: MyQotAccountSettingsPresenterInterface,
         router: MyQotAccountSettingsRouterInterface) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter.setupView()
    }
}

// MARK: - MyQotAccountSettingsInteractorInterface
extension MyQotAccountSettingsInteractor: MyQotAccountSettingsInteractorInterface {

    func userProfile(_ completion: @escaping (UserProfileModel?) -> Void) {
        worker.getUserProfile { (userProfile) in
            completion(userProfile)
        }
    }

    func accountSettingsText(_ completion: @escaping(String) -> Void) {
        worker.accountSettingsText { (text) in
            completion(text)
        }
    }

    func contactText(_ completion: @escaping(String) -> Void) {
        worker.contactText { (text) in
            completion(text)
        }
    }

    func emailText(_ completion: @escaping(String) -> Void) {
        worker.emailText { (text) in
            completion(text)
        }
    }

    func userAgeText(_ completion: @escaping(String) -> Void) {
        worker.dateOfBirthText { (text) in
            completion(text)
        }
    }

    func companyText(_ completion: @escaping(String) -> Void) {
        worker.companyText { (text) in
            completion(text)
        }
    }

    func personalDataText(_ completion: @escaping(String) -> Void) {
        worker.personalDataText { (text) in
            completion(text)
        }
    }

    func heightText(_ completion: @escaping(String) -> Void) {
        worker.heightText { (text) in
            completion(text)
        }
    }

    func weightText(_ completion: @escaping(String) -> Void) {
        worker.weightText { (text) in
            completion(text)
        }
    }

    func accountText(_ completion: @escaping(String) -> Void) {
        worker.accountText { (text) in
            completion(text)
        }
    }

    func changePasswordText(_ completion: @escaping(String) -> Void) {
        worker.changePasswordText { (text) in
            completion(text)
        }
    }

    func protectYourAccountText(_ completion: @escaping(String) -> Void) {
        worker.protectYourAccountText { (text) in
            completion(text)
        }
    }

    func logoutQotText(_ completion: @escaping(String) -> Void) {
        worker.logoutQotText { (text) in
            completion(text)
        }
    }

    func withoutDeletingAccountText(_ completion: @escaping(String) -> Void) {
        worker.withoutDeletingAccountText { (text) in
            completion(text)
        }
    }

    var changePasswordKey: String {
        return worker.changePasswordKey
    }

    var logoutQOTKey: String {
        return worker.logoutQOTKey
    }

    func logout() {
        worker.logout()
    }

    func showLogoutAlert() {
        presenter.showLogoutAlert()
    }

    func showResetPasswordAlert() {
        presenter.showResetPasswordAlert()
    }

    func resetPassword() {
        router.showProgressHUD()
        worker.resetPassword (completion: {[weak self] error in
            self?.router.hideProgressHUD()
            guard let alertType = self?.worker.alertType(for: error) else { return }
            self?.router.showAlert(alertType)
        })
    }

    func presentEditAccountSettings() {
        router.presentEditAccountSettings()
    }
}
