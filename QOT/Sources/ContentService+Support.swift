//
//  ContentService+MQotSupport.swift
//  QOT
//
//  Created by Ashish Maheshwari on 13.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

extension ContentService {
    
    enum Support: String, CaseIterable, Predicatable {
        case support = "support_support"
        case areYouMissingSomething = "support_are_you_missing_something"
        case learnHowToUseQot = "support_learn_how_to_use_qot"
        case contactUsForAnyQuestion = "support_contact_us_for_any_question"
        case checkTheMostAskedQuestion = "support_check_the_most_asked_questions"
        case featureRequest = "support_feature_request"
        case tutorial = "support_tutorial"
        case contactSupport = "support_contact_support"
        case faq = "support_faq"
        
        
        var predicate: NSPredicate {
            return NSPredicate(tag: rawValue)
        }
    }
}
