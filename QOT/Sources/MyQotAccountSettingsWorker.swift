//
//  MyQotAccountSettingsWorker.swift
//  QOT
//
//  Created by Ashish Maheshwari on 08.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class MyQotAccountSettingsWorker {

    // MARK: - Properties

    private var userEmail: String?
    private let userService: qot_dal.UserService
    private let contentService: qot_dal.ContentService
    private let networkManager: NetworkManager

    // MARK: - Init

    init(userService: qot_dal.UserService, contentService: qot_dal.ContentService, networkManager: NetworkManager) {
        self.userService = userService
        self.contentService = contentService
        self.networkManager = networkManager
    }

    func logout() {
        qot_dal.SessionService.main.logout()
        ExtensionsDataManager.didUserLogIn(false)
    }

    func resetPassword(completion: @escaping (NetworkError?) -> Void) {
        guard let email = userEmail else {
            completion(nil)
            return
        }
        networkManager.performResetPasswordRequest(username: email, completion: { error in
            completion(error)
        })
    }

    func alertType(for error: NetworkError?) -> AlertType {
        guard let error = error else { return .resetPassword }
        switch error.type {
        case .noNetworkConnection:
            return .noNetworkConnection
        case .notFound:
            return .emailNotFound
        default:
            return .unknown
        }
    }

    func getUserProfile(_ completion: @escaping (UserProfileModel?) -> Void) {
        userService.getUserData {[weak self] (user) in
            let profile = self?.formProfile(for: user)
            self?.userEmail = profile?.email
            completion(profile)
        }
    }
}

// MARK: - ContentService

extension MyQotAccountSettingsWorker {

    func accountSettingsText(_ completion: @escaping(String) -> Void) {
        contentService.getContentItemByPredicate(ContentService.AccountSettings.Profile.accountSettings.predicate) {(contentItem) in
            completion(contentItem?.valueText ?? "")
        }
    }

    func contactText(_ completion: @escaping(String) -> Void) {
        contentService.getContentItemByPredicate(ContentService.AccountSettings.Profile.contact.predicate) {(contentItem) in
            completion(contentItem?.valueText ?? "")
        }
    }

    func emailText(_ completion: @escaping(String) -> Void) {
        contentService.getContentItemByPredicate(ContentService.AccountSettings.Profile.email.predicate) {(contentItem) in
            completion(contentItem?.valueText ?? "")
        }
    }

    func dateOfBirthText(_ completion: @escaping(String) -> Void) {
        contentService.getContentItemByPredicate(ContentService.AccountSettings.Profile.yearOfBirth.predicate) {(contentItem) in
            completion(contentItem?.valueText ?? "")
        }
    }

    func companyText(_ completion: @escaping(String) -> Void) {
        contentService.getContentItemByPredicate(ContentService.AccountSettings.Profile.company.predicate) {(contentItem) in
            completion(contentItem?.valueText ?? "")
        }
    }

    func personalDataText(_ completion: @escaping(String) -> Void) {
        contentService.getContentItemByPredicate(ContentService.AccountSettings.Profile.personalData.predicate) {(contentItem) in
            completion(contentItem?.valueText ?? "")
        }
    }

    func heightText(_ completion: @escaping(String) -> Void) {
        contentService.getContentItemByPredicate(ContentService.AccountSettings.Profile.height.predicate) {(contentItem) in
            completion(contentItem?.valueText ?? "")
        }
    }

    func weightText(_ completion: @escaping(String) -> Void) {
        contentService.getContentItemByPredicate(ContentService.AccountSettings.Profile.weight.predicate) {(contentItem) in
            completion(contentItem?.valueText ?? "")
        }
    }

    func accountText(_ completion: @escaping(String) -> Void) {
        contentService.getContentItemByPredicate(ContentService.AccountSettings.Profile.account.predicate) {(contentItem) in
            completion(contentItem?.valueText ?? "")
        }
    }

    func changePasswordText(_ completion: @escaping(String) -> Void) {
        contentService.getContentItemByPredicate(ContentService.AccountSettings.Profile.changePassword.predicate) {(contentItem) in
            completion(contentItem?.valueText ?? "")
        }
    }

    func protectYourAccountText(_ completion: @escaping(String) -> Void) {
        contentService.getContentItemByPredicate(ContentService.AccountSettings.Profile.protectYourAccount.predicate) {(contentItem) in
            completion(contentItem?.valueText ?? "")
        }
    }

    func logoutQotText(_ completion: @escaping(String) -> Void) {
        contentService.getContentItemByPredicate(ContentService.AccountSettings.Profile.logoutQot.predicate) {(contentItem) in
            completion(contentItem?.valueText ?? "")
        }
    }

    func withoutDeletingAccountText(_ completion: @escaping(String) -> Void) {
        contentService.getContentItemByPredicate(ContentService.AccountSettings.Profile.withoutDeletingAccountText.predicate) {(contentItem) in
            completion(contentItem?.valueText ?? "")
        }
    }

    var changePasswordKey: String {
        return ContentService.AccountSettings.Profile.changePassword.rawValue
    }

    var logoutQOTKey: String {
        return ContentService.AccountSettings.Profile.logoutQot.rawValue
    }
}

// MARK: - Private extension

private extension MyQotAccountSettingsWorker {
    func getUserEmail(_ completion: @escaping (String) -> Void) {
        userService.getUserData {[weak self] (user) in
            let profile = self?.formProfile(for: user)
            completion(profile?.email ?? "")
        }
    }

    func formProfile(for user: QDMUser?) -> UserProfileModel? {
        return UserProfileModel(imageURL: user?.profileImage?.url(),
                                givenName: user?.givenName,
                                familyName: user?.familyName,
                                position: user?.jobTitle,
                                memberSince: user?.memberSince ?? Date(),
                                company: user?.company,
                                email: user?.email,
                                telephone: user?.telephone,
                                gender: user?.gender,
                                height: user?.height ?? 150,
                                heightUnit: user?.heightUnit ?? "",
                                weight: user?.weight ?? 60,
                                weightUnit: user?.weightUnit ?? "",
                                birthday: user?.dateOfBirth ?? "")
    }
}
