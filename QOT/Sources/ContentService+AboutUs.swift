//
//  ContentService+AboutUs.swift
//  QOT
//
//  Created by Ashish Maheshwari on 13.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

extension ContentService {

    enum AboutUs: String, CaseIterable, Predicatable {
        case aboutTignumSubtitle = "about_tignum_subtitle"
        case contentAndCopyrightSubtitle = "about_tignum_content_and_copyright_subtitle"
        case privacySubtitle = "about_tignum_privacy_subtitle"
        case qotBenefitsSubtitle = "about_tignum_qot_benefits_subtitle"
        case termsAndCOnditionSubtitle = "about_tignum_terms_and_condition_subtitle"
        case qotBenefits = "about_tignum_qot_benefits"
        case aboutTignum = "about_tignum_about_tignum"
        case privacy = "about_tignum_privay"
        case termsAndConditions = "about_tignum_terms_conditions"
        case copyright = "about_tignum_content_copyright"

        var predicate: NSPredicate {
            return NSPredicate(dalSearchTag: rawValue)
        }
    }
}
