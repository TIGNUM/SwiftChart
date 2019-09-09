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

    // MARK: - Init

    init(userService: qot_dal.UserService, contentService: qot_dal.ContentService) {
        self.userService = userService
        self.contentService = contentService
    }

    func logout() {
        qot_dal.SessionService.main.logout()
        ExtensionsDataManager.didUserLogIn(false)
    }

    func alertType(for error: QOTNetworkError?) -> AlertType {
        guard let error = error else { return .unknown }
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

    var accountSettingsText: String {
        return ScreenTitleService.main.localizedString(for: .AccountSettingsAccountSettings)
    }

    var contactText: String {
        return ScreenTitleService.main.localizedString(for: .AccountSettingsContact)
    }

    var emailText: String {
        return ScreenTitleService.main.localizedString(for: .AccountSettingsEmail)
    }

    var dateOfBirthText: String {
        return ScreenTitleService.main.localizedString(for: .AccountSettingsYearOfBirth)
    }

    var companyText: String {
        return ScreenTitleService.main.localizedString(for: .AccountSettingsCompany)
    }

    var personalDataText: String {
        return ScreenTitleService.main.localizedString(for: .AccountSettingsPersonalData)
    }

    var heightText: String {
        return ScreenTitleService.main.localizedString(for: .AccountSettingsHeight)
    }

    var weightText: String {
        return ScreenTitleService.main.localizedString(for: .AccountSettingsWeight)
    }

    var accountText: String {
        return ScreenTitleService.main.localizedString(for: .AccountSettingsAccount)
    }

    var changePasswordText: String {
        return ScreenTitleService.main.localizedString(for: .AccountSettingsChangePassword)
    }

    var protectYourAccountText: String {
        return ScreenTitleService.main.localizedString(for: .AccountSettingsProtectYourAccount)
    }

    var logoutQotText: String {
        return ScreenTitleService.main.localizedString(for: .AccountSettingsLogoutQot)
    }

    var withoutDeletingAccountText: String {
        return ScreenTitleService.main.localizedString(for: .AccountSettingsWithoutDeletingAccountText)
    }

    var changePasswordKey: String {
        return Tags.AccountSettingsChangePassword.rawValue
    }

    var logoutQOTKey: String {
        return Tags.AccountSettingsLogoutQot.rawValue
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
