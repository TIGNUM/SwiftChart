//
//  ContentService+MyQotProfile.swift
//  QOT
//
//  Created by Ashish Maheshwari on 08.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

extension ContentService {

    struct MyQot {
        enum Profile: String, CaseIterable, Predicatable {
            case memberSince = "my_profile_member_since"
            case myProfile = "my_profile_my_profile"
            case accountSettings = "my_profile_account_settings"
            case manageYourProfileDetails = "my_profile_manage_your_profile_details"
            case appSettings = "my_profile_app_settings"
            case enableNotifications = "my_profile_enable_notifications"
            case support = "my_profile_support"
            case walkthroughOurFeatures = "my_profile_walkthrough_our_features"
            case aboutTignum = "my_profile_about_tignum"
            case learnMoreAboutUs = "my_profile_learn_more_about_us"
            
            var predicate: NSPredicate {
                return NSPredicate(tag: rawValue)
            }
        }
    }
}
