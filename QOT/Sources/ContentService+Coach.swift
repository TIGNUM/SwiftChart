//
//  ContentService+Coach.swift
//  QOT
//
//  Created by Anais Plancoulaine on 11.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

extension ContentService {

    enum Coach: String, CaseIterable, Predicatable {
        case search = "coach_search"
        case tools = "coach_tools"
        case sprint = "coach_sprint"
        case event = "coach_event"
        case challenge = "coach_challenge"

        var predicate: NSPredicate {
            return NSPredicate(tag: rawValue)
        }
    }
}
