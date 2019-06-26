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
    case randomContent = "random-content"
    case weeklyPeakPerformance = "weekly-peak-performance"
    case toBeVision = "to-be-vision"
    case myPreps = "prepare-my-preps"
    case comingEvent = "coming-event"
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
    case contentItem = "contentItem"
    case fitbitApp = "fitbit"
    case signingVerificationCode = "verificationCode"
    case profile = "profile"
    case siriSettings = "siri-settings"
    case qrcode0001 = "qrcode-open-0001"
    case qrcode0002 = "qrcode-open-0002"
    case qrcode0003 = "qrcode-open-0003"
    case qrcode0004 = "qrcode-open-0004"
    var queryName: String {
        switch self {
        case .fitbit: return "code"
        case .dailyPrep: return "groupID"
        case .preparation: return "#"
        case .randomContent,
             .contentItem,
             .featureExplainer: return "contentID"
        case .contentCategory: return "collectionID"
        case .fitbitAuthrefresh,
             .toBeVision,
             .myPreps,
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
             .latestWhatsHotArticle,
             .profile,
             .siriSettings: return ""
        default:
            return ""
        }
    }

    var alternativeURLString: String! {
        switch self {
        case .fitbitApp: return "https://itunes.apple.com/us/app/fitbit/id462638897?mt=8"
        default:
            return ""
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
             .meTravel: return AppCoordinator.Router.Destination(tabBar: .data, topTabBar: .data)
        case .meMyWhy: return AppCoordinator.Router.Destination(tabBar: .data, topTabBar: .data)
        case .guide: return AppCoordinator.Router.Destination(tabBar: .guide, topTabBar: .guide)
        case .prepare: return AppCoordinator.Router.Destination(tabBar: .prepare, topTabBar: .coach)
        case .myPreps: return AppCoordinator.Router.Destination(tabBar: .prepare, topTabBar: .myPrep)
        case .prepareProblem: return AppCoordinator.Router.Destination(tabBar: .prepare, topTabBar: .coach, chatSection: .problem)
        case .prepareEvent: return AppCoordinator.Router.Destination(tabBar: .prepare, topTabBar: .coach, chatSection: .event)
        case .preferencesSyncCalendar: return AppCoordinator.Router.Destination(preferences: .calendarSync)
        case .preferencesNotification: return AppCoordinator.Router.Destination(preferences: .notifications)
        case .latestWhatsHotArticle: return AppCoordinator.Router.Destination(tabBar: .learn, topTabBar: .whatsHot)
        case .toBeVision: return AppCoordinator.Router.Destination(tabBar: .tbv, topTabBar: .toBeVision)
        case .comingEvent: return AppCoordinator.Router.Destination(tabBar: .prepare, topTabBar: .myPrep)
        default: return nil
        }
    }

    func queryParameter(url: URL) -> String? {
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
        guard let urlTypes = Bundle.main.infoDictionary?["CFBundleURLTypes"] as? [[String: Any]] else { return nil }
        #if DEBUG
        let schemes = urlTypes.first?["CFBundleURLSchemes"] as? [String]
        #else
        let schemes = urlTypes.last?["CFBundleURLSchemes"] as? [String]
        #endif
        guard let urlSchemes = schemes else { return nil }
        let preparation = URLScheme.preparation
        return "\(urlSchemes[0])://\(preparation.rawValue)\(preparation.queryName)\(localID)"
    }

    static func isLaunchableHost(host: String?) -> Bool {
        guard let host = host else { return false }
        return host == URLScheme.fitbit.rawValue ||
            host == URLScheme.preparation.rawValue ||
            host == URLScheme.signingVerificationCode.rawValue ||
            host == URLScheme.toBeVision.rawValue ||
            host == URLScheme.prepareEvent.rawValue ||            
            host == URLScheme.featureExplainer.rawValue ||
            host == URLScheme.profile.rawValue ||
            host == URLScheme.comingEvent.rawValue ||
            host == URLScheme.siriSettings.rawValue ||
            host == URLScheme.contentCategory.rawValue ||
            host == URLScheme.qrcode0001.rawValue ||
            host == URLScheme.qrcode0002.rawValue ||
            host == URLScheme.qrcode0003.rawValue ||
            host == URLScheme.qrcode0004.rawValue
    }
}
