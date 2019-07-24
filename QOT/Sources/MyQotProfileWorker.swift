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
        return ContentService.MyQot.Profile.accountSettings.rawValue
    }
    var appSettingsKey: String {
        return ContentService.MyQot.Profile.appSettings.rawValue
    }
    var supportKey: String {
        return ContentService.MyQot.Profile.support.rawValue
    }
    var aboutTignumKey: String {
        return ContentService.MyQot.Profile.aboutTignum.rawValue
    }

    func myProfileText() {
        dispatchGroup.enter()
        contentService.getContentItemByPredicate(ContentService.MyQot.Profile.myProfile.predicate) {[weak self] (contentItem) in
            self?.myProfileTxt = contentItem?.valueText ?? ""
            self?.dispatchGroup.leave()
        }
    }

    func memberSinceText() {
        dispatchGroup.enter()
        contentService.getContentItemByPredicate(ContentService.MyQot.Profile.memberSince.predicate) {[weak self] (contentItem) in
            self?.memberSinceTxt = contentItem?.valueText ?? ""
            self?.dispatchGroup.leave()
        }
    }

    func accountSettingsText() {
        dispatchGroup.enter()
        contentService.getContentItemByPredicate(ContentService.MyQot.Profile.accountSettings.predicate) {[weak self] (contentItem) in
            self?.accountSettingsTxt = contentItem?.valueText ?? ""
            self?.dispatchGroup.leave()
        }
    }

    func manageYourProfileDetailsText() {
        dispatchGroup.enter()
        contentService.getContentItemByPredicate(ContentService.MyQot.Profile.manageYourProfileDetails.predicate) {[weak self] (contentItem) in
            self?.manageYourProfileDetailsTxt = contentItem?.valueText ?? ""
            self?.dispatchGroup.leave()
        }
    }

    func appSettingsText() {
        dispatchGroup.enter()
        contentService.getContentItemByPredicate(ContentService.MyQot.Profile.appSettings.predicate) {[weak self] (contentItem) in
            self?.appSettingsTxt = contentItem?.valueText ?? ""
            self?.dispatchGroup.leave()
        }
    }

    func enableNotificationsText() {
        dispatchGroup.enter()
        contentService.getContentItemByPredicate(ContentService.MyQot.Profile.enableNotifications.predicate) {[weak self] (contentItem) in
            self?.enableNotificationsTxt = contentItem?.valueText ?? ""
            self?.dispatchGroup.leave()
        }
    }

    func supportText() {
        dispatchGroup.enter()
        contentService.getContentItemByPredicate(ContentService.MyQot.Profile.support.predicate) {[weak self] (contentItem) in
            self?.supportTxt = contentItem?.valueText ?? ""
            self?.dispatchGroup.leave()
        }
    }

    func walkthroughOurFeaturesText() {
        dispatchGroup.enter()
        contentService.getContentItemByPredicate(ContentService.MyQot.Profile.walkthroughOurFeatures.predicate) {[weak self] (contentItem) in
            self?.walkthroughOurFeaturesTxt = contentItem?.valueText ?? ""
            self?.dispatchGroup.leave()
        }
    }

    func aboutTignumText() {
        dispatchGroup.enter()
        contentService.getContentItemByPredicate(ContentService.MyQot.Profile.aboutTignum.predicate) {[weak self] (contentItem) in
            self?.aboutTignumTxt = contentItem?.valueText ?? ""
            self?.dispatchGroup.leave()
        }
    }

    func learnMoreAboutUsText() {
        dispatchGroup.enter()
        contentService.getContentItemByPredicate(ContentService.MyQot.Profile.learnMoreAboutUs.predicate) {[weak self] (contentItem) in
            self?.learnMoreAboutUsTxt = contentItem?.valueText ?? ""
            self?.dispatchGroup.leave()
        }
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
