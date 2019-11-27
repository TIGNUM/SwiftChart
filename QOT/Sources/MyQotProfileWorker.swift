//
//  MyQotWorker.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class MyQotProfileWorker {

    // MARK: - Properties
    private let userService: qot_dal.UserService
    private let contentService: qot_dal.ContentService
    private let dispatchGroup = DispatchGroup()

    private var accountSettingsText = ""
    private var manageYourProfileDetailsText = ""
    private var appSettingsText = ""
    private var enableNotificationsText = ""
    private var supportText = ""
    private var walkthroughOurFeaturesText = ""
    private var aboutTignumText = ""
    private var learnMoreAboutUsText = ""
    var myProfileText = ""
    var memberSinceText = ""
    var userProfile: UserProfileModel?

    // MARK: - Init

    init(userService: qot_dal.UserService, contentService: qot_dal.ContentService) {
        self.userService = userService
        self.contentService = contentService
    }

    lazy var menuItems: [MyQotProfileModel.TableViewPresentationData] = {
        var items = [MyQotProfileModel.TableViewPresentationData]()
        let accountSettings = MyQotProfileModel.TableViewPresentationData(heading: accountSettingsText, subHeading: manageYourProfileDetailsText)
        let appSettings = MyQotProfileModel.TableViewPresentationData(heading: appSettingsText, subHeading: enableNotificationsText)
        let support = MyQotProfileModel.TableViewPresentationData(heading: supportText, subHeading: walkthroughOurFeaturesText)
        let aboutTignum = MyQotProfileModel.TableViewPresentationData(heading: aboutTignumText, subHeading: learnMoreAboutUsText)
        items = [accountSettings, appSettings, support, aboutTignum]
        return items
    }()

    func getData(_ completion: @escaping (UserProfileModel?) -> Void) {
        getUserProfile()
        setupMyProfileText()
        setupMemberSinceText()
        setupAccountSettingsText()
        setupManageYourProfileDetailsText()
        setupAppSettingsText()
        setupEnableNotificationsText()
        setupSupportText()
        setupWalkthroughOurFeaturesText()
        setupAboutTignumText()
        setupLearnMoreAboutUsText()
        dispatchGroup.notify(queue: .main) {
            completion(self.userProfile)
        }
    }
}

// MARK: - ContentService
private extension MyQotProfileWorker {

    func setupMyProfileText() {
        myProfileText = AppTextService.get(AppTextKey.my_qot_my_profile_section_header_title)
    }

    func setupMemberSinceText() {
        memberSinceText = AppTextService.get(AppTextKey.my_qot_my_profile_section_header_label_member_since)
    }

    func setupAccountSettingsText() {
        accountSettingsText = AppTextService.get(AppTextKey.my_qot_my_profile_section_account_settings_title)
    }

    func setupManageYourProfileDetailsText() {
        manageYourProfileDetailsText = AppTextService.get(AppTextKey.my_qot_my_profile_section_account_settings_subtitle)
    }

    func setupAppSettingsText() {
        appSettingsText = AppTextService.get(AppTextKey.my_qot_my_profile_section_app_settings_title)
    }

    func setupEnableNotificationsText() {
        enableNotificationsText = AppTextService.get(AppTextKey.my_qot_my_profile_section_app_settings_subtitle)
    }

    func setupSupportText() {
        supportText = AppTextService.get(AppTextKey.my_qot_my_profile_section_support_title)
    }

    func setupWalkthroughOurFeaturesText() {
        walkthroughOurFeaturesText = AppTextService.get(AppTextKey.my_qot_my_profile_section_support_subtitle)
    }

    func setupAboutTignumText() {
        aboutTignumText = AppTextService.get(AppTextKey.my_qot_my_profile_section_about_us_title)
    }

    func setupLearnMoreAboutUsText() {
        learnMoreAboutUsText = AppTextService.get(AppTextKey.my_qot_my_profile_section_about_us_subtitle)
    }

    func getUserProfile() {
        dispatchGroup.enter()
        userService.getUserData {[weak self] (user) in
            let profile = self?.formProfile(for: user)
            self?.userProfile = profile
            self?.dispatchGroup.leave()
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
