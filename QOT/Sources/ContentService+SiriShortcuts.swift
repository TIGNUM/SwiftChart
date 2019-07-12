//
//  ContentService+SiriShortcuts.swift
//  QOT
//
//  Created by Ashish Maheshwari on 08.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

extension ContentService {

    enum Siri: String, CaseIterable, Predicatable {
        case siriToBeVisionTitle = "siri_title_tobevision"
        case siriUpcomingEventTitle = "siri_title_upcomingevent"
        case siriWhatsHotTitle = "siri_title_whatshot"
        case siriDailyPrepTitle = "siri_title_dailyprep"
        case siriExplanation = "siri_explanation_header"
        case siriToBeVisionSuggestionPhrase = "siri_suggestionphrase_tobevision"
        case siriUpcomingEventSuggestionPhrase = "siri_suggestionphrase_upcomingevent"
        case siriDailyPrepSuggestionPhrase = "siri_suggestionphrase_dailyprep"
        case siriWhatsHotSuggestionPhrase = "siri_suggestionphrase_whatshot"

        var predicate: NSPredicate {
            return NSPredicate(dalSearchTag: rawValue)
        }
    }
}
