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

    private var accountSettingsTxt = ""
    private var manageYourProfileDetailsTxt = ""
    private var appSettingsTxt = ""
    private var enableNotificationsTxt = ""
    private var supportTxt = ""
    private var walkthroughOurFeaturesTxt = ""
    private var aboutTignumTxt = ""
    private var learnMoreAboutUsTxt = ""
    var myProfileTxt = ""
    var memberSinceTxt = ""
    private var userProfile: UserProfileModel?

    // MARK: - Init

    init(userService: qot_dal.UserService, contentService: qot_dal.ContentService) {
        self.userService = userService
        self.contentService = contentService
    }

    lazy var menuItems: [MyQotProfileModel.TableViewPresentationData] = {
        var items = [MyQotProfileModel.TableViewPresentationData]()
        let accountSettings = MyQotProfileModel.TableViewPresentationData(headingKey: accountSettingsKey, heading: accountSettingsTxt, subHeading: manageYourProfileDetailsTxt)
        let appSettings = MyQotProfileModel.TableViewPresentationData(headingKey: appSettingsKey, heading: appSettingsTxt, subHeading: enableNotificationsTxt)
        let support = MyQotProfileModel.TableViewPresentationData(headingKey: supportKey, heading: supportTxt, subHeading: walkthroughOurFeaturesTxt)
        let aboutTignum = MyQotProfileModel.TableViewPresentationData(headingKey: aboutTignumKey, heading: aboutTignumTxt, subHeading: learnMoreAboutUsTxt)
        items = [accountSettings, appSettings, support, aboutTignum]
        return items
    }()

    func getData(_ completion: @escaping (UserProfileModel?) -> Void) {
        getUserProfile()
        myProfileText()
        memberSinceText()
        accountSettingsText()
        manageYourProfileDetailsText()
        appSettingsText()
        enableNotificationsText()
        supportText()
        walkthroughOurFeaturesText()
        aboutTignumText()
        learnMoreAboutUsText()
        dispatchGroup.notify(queue: .main) {
            completion(self.userProfile)
        }
    }
}

// MARK: - ContentService
private extension MyQotProfileWorker {

    var accountSettingsKey: String {
        return Tags.MyQotProfileAccountSettings.rawValue
    }
    var appSettingsKey: String {
        return Tags.MyQotProfileAppSettings.rawValue
    }
    var supportKey: String {
        return Tags.MyQotProfileSupport.rawValue
    }
    var aboutTignumKey: String {
        return Tags.MyQotProfileAboutTignum.rawValue
    }

    func myProfileText() {
        myProfileTxt = ScreenTitleService.main.localizedString(for: .MyQotMyProfile)
    }

    func memberSinceText() {
        memberSinceTxt = ScreenTitleService.main.localizedString(for: .MyQotMemberSince)
    }

    func accountSettingsText() {
        accountSettingsTxt = ScreenTitleService.main.localizedString(for: .MyQotProfileAccountSettings)
    }

    func manageYourProfileDetailsText() {
        manageYourProfileDetailsTxt = ScreenTitleService.main.localizedString(for: .MyQotManageYourProfileDetails)
    }

    func appSettingsText() {
        appSettingsTxt = ScreenTitleService.main.localizedString(for: .MyQotProfileAppSettings)
    }

    func enableNotificationsText() {
        enableNotificationsTxt = ScreenTitleService.main.localizedString(for: .MyQotEnableNotifications)
    }

    func supportText() {
        supportTxt = ScreenTitleService.main.localizedString(for: .MyQotProfileSupport)
    }

    func walkthroughOurFeaturesText() {
        walkthroughOurFeaturesTxt = ScreenTitleService.main.localizedString(for: .MyQotWalkthroughOurFeatures)
    }

    func aboutTignumText() {
        aboutTignumTxt = ScreenTitleService.main.localizedString(for: .MyQotProfileAboutTignum)
    }

    func learnMoreAboutUsText() {
        learnMoreAboutUsTxt = ScreenTitleService.main.localizedString(for: .MyQotLearnMoreAboutUs)
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
