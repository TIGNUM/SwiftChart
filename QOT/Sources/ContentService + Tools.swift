//
//  ContentService + Tools.swift
//  QOT
//
//  Created by Anais Plancoulaine on 11.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

extension ContentService {

    enum Tools: String, CaseIterable, Predicatable {
        case mindset = "tools_mindset"
        case nutrition = "tools_nutrition"
        case movement = "tools_movement"
        case recovery = "tools_recovery"
        case habituation = "tools_habituation"
        var predicate: NSPredicate {
            return NSPredicate(tag: rawValue)
        }
    }
}
