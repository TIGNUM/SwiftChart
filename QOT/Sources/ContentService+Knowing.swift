//
//  ContentService+Knowing.swift
//  QOT
//
//  Created by Ashish Maheshwari on 08.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

extension ContentService {
    struct Navigation {
        enum FirstLevel: String, CaseIterable, Predicatable {
            case knowPageTitle = "know-feed-level-01-page-title"
            case knowSectionTitleStrategies = "know-feed-level-01-section-title-strategies"
            case knowSectionSubtitleStrategies = "know-feed-level-01-section-subtitle-strategies"
            case knowSectionTitleWhatsHot = "know-feed-level-01-section-title-whats-hot"
            case knowSectionSubtitleWhatsHot = "know-feed-level-01-section-subtitle-whats-hot"

            var predicate: NSPredicate {
                return NSPredicate(tag: rawValue)
            }
        }
    }
}
