//
//  MyQotWorker.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class MyQotProfileWorker {

    // MARK: - Properties
    private let services: Services
    private let userProfileManager: UserProfileManager?

    // MARK: - Init

    init(services: Services, syncManager: SyncManager) {
        self.services = services
        self.userProfileManager = UserProfileManager(services, syncManager)
    }

    var myProfileText: String {
        return services.contentService.localizedString(for: ContentService.MyQot.Profile.myProfile.predicate) ?? ""
    }

    var memberSinceText: String {
        return services.contentService.localizedString(for: ContentService.MyQot.Profile.memberSince.predicate) ?? ""
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

    func profile() -> UserProfileModel? {
        return userProfileManager?.profile()
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
    var accountSettingsText: String {
        return services.contentService.localizedString(for: ContentService.MyQot.Profile.accountSettings.predicate) ?? ""
    }
    var manageYourProfileDetailsText: String {
        return services.contentService.localizedString(for: ContentService.MyQot.Profile.manageYourProfileDetails.predicate) ?? ""
    }
    var appSettingsText: String {
        return services.contentService.localizedString(for: ContentService.MyQot.Profile.appSettings.predicate) ?? ""
    }
    var enableNotificationsText: String {
        return services.contentService.localizedString(for: ContentService.MyQot.Profile.enableNotifications.predicate) ?? ""
    }
    var supportText: String {
        return services.contentService.localizedString(for: ContentService.MyQot.Profile.support.predicate) ?? ""
    }
    var walkthroughOurFeaturesText: String {
        return services.contentService.localizedString(for: ContentService.MyQot.Profile.walkthroughOurFeatures.predicate) ?? ""
    }
    var aboutTignumText: String {
        return services.contentService.localizedString(for: ContentService.MyQot.Profile.aboutTignum.predicate) ?? ""
    }
    var learnMoreAboutUsText: String {
        return services.contentService.localizedString(for: ContentService.MyQot.Profile.learnMoreAboutUs.predicate) ?? ""
    }
}
