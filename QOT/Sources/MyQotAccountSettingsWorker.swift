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
        return AppTextService.get(AppTextKey.my_qot_my_profile_account_settings_view_title)
    }

    var contactText: String {
        return AppTextService.get(AppTextKey.my_qot_my_profile_account_settings_view_contact_title)
    }

    var emailText: String {
        return AppTextService.get(AppTextKey.my_qot_my_profile_account_settings_view_email_title)
    }

    var dateOfBirthText: String {
        return AppTextService.get(AppTextKey.my_qot_my_profile_account_settings_view_year_of_birth_title)
    }

    var companyText: String {
        return ScreenTitleService.main.localizedString(for: .AccountSettingsCompany)
    }

    var personalDataText: String {
        return AppTextService.get(AppTextKey.my_qot_my_profile_account_settings_view_personal_data_title)
    }

    var accountText: String {
        return AppTextService.get(AppTextKey.my_qot_my_profile_account_settings_view_account_title)
    }

    var changePasswordText: String {
        return AppTextService.get(AppTextKey.my_qot_my_profile_account_settings_view_change_password_title)
    }

    var protectYourAccountText: String {
        return AppTextService.get(AppTextKey.my_qot_my_profile_account_settings_view_protect_your_account_title)
    }

    var logoutQotText: String {
        return AppTextService.get(AppTextKey.my_qot_my_profile_account_settings_view_logout_title)
    }

    var withoutDeletingAccountText: String {
        return AppTextService.get(AppTextKey.my_qot_my_profile_account_settings_view_deleting_your_account_title)
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
