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
    case fitbitAuthrefresh = "fitbit-authrefresh"
    case preparation = "preparation"
    case dailyPrep = "morning-interview"
    case weeklyChoices = "weekly-choices"
    case randomContent = "random-content"
    case weeklyPeakPerformance = "weekly-peak-performance"
    case toBeVision = "to-be-vision"
    case myPreps = "prepare-my-preps"
    case weeklyChoicesReminder = "weekly-choices-reminder"
    case contentCategory = "content-category"
    case featureExplainer = "feature-explainer"
    case strategies = "strategies"
    case meUniverse = "me-universe"
    case meMyWhy = "me-my-why"
    case meChoices = "me-choices"
    case meActivity = "me-activity"
    case meIntensity = "me-intensity"
    case meMeeting = "me-meeting"
    case meSleep = "me-sleep"
    case mePeakPerformance = "me-peakperformance"
    case meQotPartner = "me-qot-partner"
    case meTravel = "me-travel"
    case preferencesSyncCalendar = "preferences-sync-calendar"
    case preferencesNotification = "preferences-notification"
    case addSensor = "add-sensor"
    case prepare = "prepare"
    case prepareProblem = "prepare-problem"
    case prepareEvent = "prepare-event"
    case prepareDay = "prepare-day"
    case library = "library"
    case guide = "guide"
    case latestWhatsHotArticle = "latest-whats-hot-article"

    var queryName: String {
        switch self {
        case .fitbit: return "code"
        case .dailyPrep: return "groupID"
        case .preparation: return "#"
        case .randomContent,
             .featureExplainer: return "contentID"
        case .contentCategory: return "collectionID"
        case .weeklyChoices,
             .fitbitAuthrefresh,
             .weeklyPeakPerformance,
             .toBeVision,
             .myPreps,
             .weeklyChoicesReminder,
             .strategies,
             .meUniverse,
             .meMyWhy,
             .meChoices,
             .meActivity,
             .meIntensity,
             .meMeeting,
             .meSleep,
             .mePeakPerformance,
             .meQotPartner,
             .meTravel,
             .preferencesSyncCalendar,
             .preferencesNotification,
             .addSensor,
             .prepare,
             .prepareProblem,
             .prepareEvent,
             .prepareDay,
             .library,
             .guide,
             .latestWhatsHotArticle: return ""
        }
    }

    var destination: AppCoordinator.Router.Destination? {
        switch self {
        case .strategies: return AppCoordinator.Router.Destination(tabBar: .learn, topTabBar: .strategies)
        case .meUniverse,
             .meActivity,
             .meIntensity,
             .meMeeting,
             .meSleep,
             .mePeakPerformance,
             .meTravel: return AppCoordinator.Router.Destination(tabBar: .me, topTabBar: .myData)
        case .meMyWhy: return AppCoordinator.Router.Destination(tabBar: .me, topTabBar: .myWhy)
        case .guide: return AppCoordinator.Router.Destination(tabBar: .guide, topTabBar: .guide)
        case .prepare: return AppCoordinator.Router.Destination(tabBar: .prepare, topTabBar: .coach)
        case .myPreps,
             .weeklyPeakPerformance: return AppCoordinator.Router.Destination(tabBar: .prepare, topTabBar: .myPrep)
        case .prepareProblem: return AppCoordinator.Router.Destination(tabBar: .prepare, topTabBar: .coach, chatSection: .problem)
        case .prepareEvent: return AppCoordinator.Router.Destination(tabBar: .prepare, topTabBar: .coach, chatSection: .event)
        case .preferencesSyncCalendar: return AppCoordinator.Router.Destination(preferences: .calendarSync)
        case .preferencesNotification: return AppCoordinator.Router.Destination(preferences: .notifications)
        case .latestWhatsHotArticle: return AppCoordinator.Router.Destination(tabBar: .learn, topTabBar: .whatsHot)
        default: return nil
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
