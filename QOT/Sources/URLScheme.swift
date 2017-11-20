//
//  URLScheme.swift
//  QOT
//
//  Created by Lee Arromba on 31/08/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

enum URLScheme: String {
    case fitbit = "fitbit-integration"
    case preparation = "preparation"
    case dailyPrep = "morning-interview"
    case weeklyChoices = "weekly-choices"
    case randomContent = "random-content"
    case weeklyPeakPerformance = "weekly-peak-performance"
    case toBeVision = "to-be-vision"
    case myPreps = "prepare-my-preps"
    case weeklyChoicesReminder = "weekly-choices-reminder"

    static var allValues: [URLScheme] {
        return [
            .fitbit,
            .preparation,
            .dailyPrep,
            .weeklyChoices,
            .randomContent,
            .weeklyPeakPerformance,
            .toBeVision,
            .myPreps,
            .weeklyChoicesReminder
        ]
    }
    
    var queryName: String {
        switch self {
        case .fitbit: return "code"
        case .preparation: return "#"
        case .dailyPrep: return "groupID"
        case .randomContent: return "contentID"
        case .weeklyPeakPerformance,
             .weeklyChoices,
             .toBeVision,
             .weeklyChoicesReminder,
             .myPreps: return ""
        }
    }
    
    func queryParametter(url: URL) -> String? {
        return url.queryStringParameter(param: queryName)
    }
    
    func pushNotificationID(url: URL) -> String? {
        return url.queryStringParameter(param: "nid")
    }
    
    static func isSupportedURL(_ url: URL) -> Bool {
        guard
            let host = url.host,
            URLScheme(rawValue: host) != nil else {
                return false
        }
        return true
    }
    
    static func preparationURL(withID localID: String) -> String? {
        guard
            let urlTypes = Bundle.main.infoDictionary?["CFBundleURLTypes"] as? [[String: Any]],
            let urlSchemes = urlTypes[0]["CFBundleURLSchemes"] as? [String] else {
                return nil
        }
        
        let preparation = URLScheme.preparation
        return "\(urlSchemes[0])://\(preparation.rawValue)\(preparation.queryName)\(localID)"
    }
}
