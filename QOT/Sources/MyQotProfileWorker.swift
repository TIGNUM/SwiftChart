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
        let accountSettings = MyQotProfileModel.TableViewPresentationData(headingKey: accountSettingsKey, heading: accountSettingsText, subHeading: manageYourProfileDetailsText)
        let appSettings = MyQotProfileModel.TableViewPresentationData(headingKey: appSettingsKey, heading: appSettingsText, subHeading: enableNotificationsText)
        let support = MyQotProfileModel.TableViewPresentationData(headingKey: supportKey, heading: supportText, subHeading: walkthroughOurFeaturesText)
        let aboutTignum = MyQotProfileModel.TableViewPresentationData(headingKey: aboutTignumKey, heading: aboutTignumText, subHeading: learnMoreAboutUsText)
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

    func setupMyProfileText() {
        myProfileText = ScreenTitleService.main.localizedString(for: .MyQotMyProfile)
    }

    func setupMemberSinceText() {
        memberSinceText = ScreenTitleService.main.localizedString(for: .MyQotMemberSince)
    }

    func setupAccountSettingsText() {
        accountSettingsText = ScreenTitleService.main.localizedString(for: .MyQotProfileAccountSettings)
    }

    func setupManageYourProfileDetailsText() {
        manageYourProfileDetailsText = ScreenTitleService.main.localizedString(for: .MyQotManageYourProfileDetails)
    }

    func setupAppSettingsText() {
        appSettingsText = ScreenTitleService.main.localizedString(for: .MyQotProfileAppSettings)
    }

    func setupEnableNotificationsText() {
        enableNotificationsText = ScreenTitleService.main.localizedString(for: .MyQotEnableNotifications)
    }

    func setupSupportText() {
        supportText = ScreenTitleService.main.localizedString(for: .MyQotProfileSupport)
    }

    func setupWalkthroughOurFeaturesText() {
        walkthroughOurFeaturesText = ScreenTitleService.main.localizedString(for: .MyQotWalkthroughOurFeatures)
    }

    func setupAboutTignumText() {
        aboutTignumText = ScreenTitleService.main.localizedString(for: .MyQotProfileAboutTignum)
    }

    func setupLearnMoreAboutUsText() {
        learnMoreAboutUsText = ScreenTitleService.main.localizedString(for: .MyQotLearnMoreAboutUs)
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
