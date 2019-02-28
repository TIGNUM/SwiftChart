//
//  NSUserActivity+Keys.swift
//  Intent
//
//  Created by Javier Sanz Rozalén on 11.02.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import MobileCoreServices
import CoreSpotlight

extension NSUserActivity {
    
    // MARK: - Keys
    
    enum ActivityType: String {
        case dailyPrep = "com.qot.nsuseractivity.dailyPrep"
        case toBeVision = "com.qot.nsuseractivity.tobevision"
        case toBeVisionGenerator = "com.qot.nsuseractivity.tobevision.generator"
        case whatsHotArticle = "com.qot.nsuseractivity.whatshotArticle"
        case whatsHotArticlesList = "com.qot.nsuseractivity.whatshotList"
        case eventsList = "com.qot.nsuseractivity.eventsList"
        case event = "com.qot.nsuseractivity.event"
    }

    // MARK: - NSUserActivity

    static func activity(for type: ActivityType, arguments: [String] = []) -> NSUserActivity {
        let userActivity = NSUserActivity(activityType: type.rawValue)
        let attributes = CSSearchableItemAttributeSet(itemContentType: kUTTypeContent as String)
        attributes.keywords = arguments
        userActivity.contentAttributeSet = attributes
        return userActivity
    }
}
