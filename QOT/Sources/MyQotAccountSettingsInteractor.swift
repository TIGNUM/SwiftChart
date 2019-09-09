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

    var accountSettingsText: String {
        return worker.accountSettingsText
    }

    var contactText: String {
        return worker.contactText
    }

    var emailText: String {
        return worker.emailText
    }

    var dateOfBirthText: String {
        return worker.dateOfBirthText
    }

    var companyText: String {
        return worker.companyText
    }

    var personalDataText: String {
        return worker.personalDataText
    }

    var heightText: String {
        return worker.heightText
    }

    var weightText: String {
        return worker.weightText
    }

    var accountText: String {
        return worker.accountText
    }

    var changePasswordText: String {
        return worker.changePasswordText
    }

    var protectYourAccountText: String {
        return worker.protectYourAccountText
    }

    var logoutQotText: String {
        return worker.logoutQotText
    }

    var withoutDeletingAccountText: String {
        return worker.withoutDeletingAccountText
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

    func presentEditAccountSettings() {
        router.presentEditAccountSettings()
    }
}
