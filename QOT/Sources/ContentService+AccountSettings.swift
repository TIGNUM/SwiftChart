//
//  ContentService+AccountSettings.swift
//  QOT
//
//  Created by Ashish Maheshwari on 09.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

extension ContentService {

    struct AccountSettings {
        enum Profile: String, CaseIterable, Predicatable {
            case accountSettings = "account_settings_account_settings"
            case contact = "account_settings_contact"
            case email = "account_settings_email"
            case phone = "account_settings_phone"
            case personalData = "account_settings_personal_data"
            case height = "account_settings_height"
            case weight = "account_settings_weight"
            case account = "account_settings_account"
            case changePassword = "account_settings_change_password"
            case protectYourAccount = "account_settings_protect_your_account"
            case logoutQot = "account_settings_logout_qot"
            case withoutDeletingAccountText = "account_settings_without_deleting_your_account"

            var predicate: NSPredicate {
                return NSPredicate(dalSearchTag: rawValue)
            }
        }
    }
}
