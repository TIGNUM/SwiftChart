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

    var companyText: String {
        return worker.companyText
    }

    var logoutQotText: String {
        return worker.logoutQotText
    }

    var withoutDeletingAccountText: String {
        return worker.withoutDeletingAccountText
    }

    var logoutQOTKey: String {
        return worker.logoutQOTKey
    }

    func logout() {
        worker.logout()
    }

    func presentEditAccountSettings() {
        router.presentEditAccountSettings()
    }
}
