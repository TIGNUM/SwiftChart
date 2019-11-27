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
        return AppTextService.get(AppTextKey.my_qot_my_profile_account_settings_section_header_title)
    }

    var contactText: String {
        return AppTextService.get(AppTextKey.my_qot_my_profile_account_settings_edit_title_contact)
    }

    var emailText: String {
        return AppTextService.get(AppTextKey.my_qot_my_profile_account_settings_section_body_title_email)
    }

    var dateOfBirthText: String {
        return AppTextService.get(AppTextKey.my_qot_my_profile_account_settings_edit_title_date_of_birth)
    }

    var companyText: String {
        return AppTextService.get(AppTextKey.my_qot_my_profile_account_settings_section_body_title_company)
    }

    var logoutQotText: String {
        return AppTextService.get(AppTextKey.my_qot_my_profile_account_settings_section_logout_title)
    }

    var withoutDeletingAccountText: String {
        return AppTextService.get(AppTextKey.my_qot_my_profile_account_settings_section_logout_subtitle)
    }

    var logoutQOTKey: String {
        return AppTextService.get(AppTextKey.my_qot_my_profile_account_settings_section_logout_title)
    }
}

// MARK: - Private extension

private extension MyQotAccountSettingsWorker {
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
