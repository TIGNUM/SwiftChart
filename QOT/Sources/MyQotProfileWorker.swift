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
    private let userService: UserService
    private let contentService: ContentService
    private let dispatchGroup = DispatchGroup()
    private var accountSettingsText = ""
    private var teamSettingsText = ""
    private var manageYourProfileDetailsText = ""
    private var appSettingsText = ""
    private var enableNotificationsText = ""
    private var supportText = ""
    private var walkthroughOurFeaturesText = ""
    private var aboutTignumText = ""
    private var manageTeamSettingsText = ""
    private var learnMoreAboutUsText = ""
    var myProfileText = ""
    var memberSinceText = ""
    var hasTeam = false
    var userProfile: UserProfileModel?
    var developmentMode = false

    // MARK: - Init

    init(userService: UserService, contentService: ContentService) {
        self.userService = userService
        self.contentService = contentService
    }

    func menuItems(for types: [ProfileItemControllerType]) -> [MyQotProfileModel.TableViewPresentationData] {
        var items = [MyQotProfileModel.TableViewPresentationData]()
        types.forEach { (type) in
            var item: MyQotProfileModel.TableViewPresentationData?
            switch type {
            case .accountSettings:
                item = MyQotProfileModel.TableViewPresentationData(heading: accountSettingsText,
                                                                   subHeading: manageYourProfileDetailsText)
            case .teamSettings:
                item = MyQotProfileModel.TableViewPresentationData(heading: teamSettingsText,
                                                                   subHeading: manageTeamSettingsText)
            case .appSettings:
                item = MyQotProfileModel.TableViewPresentationData(heading: appSettingsText,
                                                                   subHeading: enableNotificationsText)
            case .support:
                item = MyQotProfileModel.TableViewPresentationData(heading: supportText,
                                                                   subHeading: walkthroughOurFeaturesText)
            case .aboutTignum:
                item = MyQotProfileModel.TableViewPresentationData(heading: aboutTignumText,
                                                                   subHeading: learnMoreAboutUsText)
            case .adminSettings:
                item = MyQotProfileModel.TableViewPresentationData(heading: "Admin settings",
                                                                   subHeading: "Settings for debug and testing")
            }
            if let menuItem = item { items.append(menuItem) }
        }

        return items
    }

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
        setupTeamSettingsText()
        setupManageTeamSettingsText()
        userHasTeam()
        dispatchGroup.notify(queue: .main) {
            completion(self.userProfile)
        }
    }
}

// MARK: - ContentService
private extension MyQotProfileWorker {

    func setupMyProfileText() {
        myProfileText = AppTextService.get(.my_qot_my_profile_section_header_title)
    }

    func setupTeamSettingsText() {
        teamSettingsText = AppTextService.get(.settings_team_settings_title)
    }

    func setupManageTeamSettingsText() {
        manageTeamSettingsText = AppTextService.get(.settings_team_settings_subtitle)
    }

    func setupMemberSinceText() {
        memberSinceText = AppTextService.get(.my_qot_my_profile_section_header_label_member_since)
    }

    func setupAccountSettingsText() {
        accountSettingsText = AppTextService.get(.my_qot_my_profile_section_account_settings_title)
    }

    func setupManageYourProfileDetailsText() {
        manageYourProfileDetailsText = AppTextService.get(.my_qot_my_profile_section_account_settings_subtitle)
    }

    func setupAppSettingsText() {
        appSettingsText = AppTextService.get(.my_qot_my_profile_section_app_settings_title)
    }

    func setupEnableNotificationsText() {
        enableNotificationsText = AppTextService.get(.my_qot_my_profile_section_app_settings_subtitle)
    }

    func setupSupportText() {
        supportText = AppTextService.get(.my_qot_my_profile_section_support_title)
    }

    func setupWalkthroughOurFeaturesText() {
        walkthroughOurFeaturesText = AppTextService.get(.my_qot_my_profile_section_support_subtitle)
    }

    func setupAboutTignumText() {
        aboutTignumText = AppTextService.get(.my_qot_my_profile_section_about_us_title)
    }

    func setupLearnMoreAboutUsText() {
        learnMoreAboutUsText = AppTextService.get(.my_qot_my_profile_section_about_us_subtitle)
    }

    func getUserProfile() {
        dispatchGroup.enter()
        userService.getUserData {[weak self] (user) in
            let profile = self?.formProfile(for: user)
            self?.userProfile = profile
            self?.dispatchGroup.leave()
        }
    }

    func getMaxChars(_ completion: @escaping (Int) -> Void) {
        TeamService.main.getTeamConfiguration { (config, error) in
            if let error = error {
             log("Error getTeamConfiguration: \(error.localizedDescription)", level: .error)
            }
            completion(config?.teamNameMaxLength ?? 0)
        }
    }

    func userHasTeam() {
        TeamService.main.getTeams {(teams, _, _) in
            if let teams = teams {
                self.hasTeam = !teams.isEmpty
            }
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
