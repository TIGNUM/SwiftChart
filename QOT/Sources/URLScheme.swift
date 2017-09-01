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
    
    static var allValues: [URLScheme] {
        return [
            .fitbit,
            .preparation,
            .dailyPrep,
            .weeklyChoices,
            .randomContent,
            .weeklyPeakPerformance
        ]
    }
    
    var queryName: String {
        switch self {
        case .fitbit: return "code"
        case .preparation: return "#"
        case .dailyPrep: return "groupID"
        case .weeklyChoices: return ""
        case .randomContent: return "contentID"
        case .weeklyPeakPerformance: return ""
        }
    }
    
    func queryParametter(url: URL) -> String? {
        return url.queryStringParameter(param: queryName)
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
