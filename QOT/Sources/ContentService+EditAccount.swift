//
//  ContentService+EditAccount.swift
//  QOT
//
//  Created by Ashish Maheshwari on 23.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

extension ContentService {

    enum EditAccount: String, CaseIterable, Predicatable {
        case editAccount = "edit_account_edit_account"
        case personalData = "edit_account_personal_data"
        case contact = "edit_account_contact"
        case name = "edit_account_name"
        case surname = "edit_account_surname"
        case gender = "edit_account_gender"
        case dateOfBirth = "edit_account_date_of_birth"
        case height = "edit_account_height"
        case weight = "edit_account_weight"
        case company = "edit_account_company"
        case title = "edit_account_title"
        case email = "edit_account_email"
        case phone = "edit_account_phone"

        var predicate: NSPredicate {
            return NSPredicate(dalSearchTag: rawValue)
        }
    }
}
