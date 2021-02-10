//
//  URLScheme.swift
//  QOT
//
//  Created by Lee Arromba on 31/08/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import qot_dal

enum URLScheme: String {
    case dailyBrief = "daily-brief" // open daily brief, parameter "bucketName"
    case ouraring = "oura-integration"
    case content_item = "content-item" // open content item which is pdf, video or audio. parameter "contentItemId"
    case knowFeed = "know-feed" // open know feed screen
    case myQOT = "my-qot" // open my qot screen
    case coachMode = "coach-mode" // open coach mode screen
    case myData = "my-data" // open My Data screen
    case createSolveAChallenge = "create-solve-a-challenge" // open creating solve a challenge screen
    case planASprint = "plan-a-sprint" // open creating a sprint screen
    case tools = "tools" // open tools main screen
    case siriShortCuts = "siri-shortcuts" // open siri setting screen
    case myPreparations = "my-preparations" // open my preparations screen
    case prepareEvent = "prepare-event" // open prepare for a event screen
    case preparation = "preparation" // open specific preparation with QDMUserPreparation's local id(qotId). parameter "identifier"
    case toBeVision = "to-be-vision" // open my to be vision screen
    case mySprints = "my-sprints" // open my sprints screen
    case myLibrary = "my-library" // open my library screen
    case myProfile = "my-profile" // open my profile screen
    case accountSetting = "account-settings" // open account settings
    case appSettings = "app-settings" // open app settings screen
    case syncedCalendars = "synced-calendars" // open synced calendars setting screen
    case activityTrackers = "activity-trackers" // open activity trackers setting screen
    case dailyCheckIn = "daily-check-in" // open daily check in screen
    case latestWhatsHotArticle = "latest-whats-hot-article"
    case support = "support" // open support screen
    case tutorial = "tutorial" // open tutorial screen
    case faq = "faq" // FAQ screen
    case usingQOT = "using-qot" // Using QOT screen
    case usingTIGNUMX = "using-tignum-x" // Using QOT screen
    case aboutTignum = "about-tignum" // open about tignum screen
    case qotBenefits = "qot-benefits" // open qot benefits screen
    case aboutTignumDetail = "about-tignum-detail" // open about tignum content screen
    case privacy = "privacy" // open privacy screen
    case termsAndConditions = "terms-and-conditions" // open terms and conditions screen
    case contentCopyrights = "content-copyrights" // open content copyrights screen
    case performanceFoundation = "performance-foundation" // open foundations
    case performanceHabituation = "performance-habituation"
    case performanceRecovery = "performance-recovery"
    case performanceNutrition = "performance-nutrition"
    case performanceMovement = "performance-movement"
    case performanceMindset = "performance-mindset"
    case randomContent = "random-content" // parameter "contentId"
    case qrcode0001 = "qrcode-open-0001"
    case qrcode0002 = "qrcode-open-0002"
    case qrcode0003 = "qrcode-open-0003"
    case qrcode0004 = "qrcode-open-0004"
    case qrcode0005 = "qrcode-open-0005"
    case qrcode0006 = "qrcode-open-0006"
    case qrcode0007 = "qrcode-open-0007"
    case qrcode0008 = "qrcode-open-0008"
    case qrcode0009 = "qrcode-open-0009"
    case qrcode0010 = "qrcode-open-0010"
    case recovery3DPlanner = "3d-recovery-planner"
    case mindsetShifterPlanner = "mindset-shifter-planner"
    case tbvTrackerPollOpened = "tbv-tracker-poll-opened"
    case tbvTrackerPollClosed = "tbv-tracker-poll-closed"
    case tbvGeneratorPollOpened = "tbv-generator-poll-opened"
    case tbvGeneratorPollClosed = "tbv-generator-poll-closed"

    // Competability fro 1.x version notifications
    case fitbit = "fitbit-integration" // IGNORE
    case fitbitAuthrefresh = "fitbit-authrefresh" // IGNORE
    case dailyPrep = "morning-interview" // dailyCheckIn
    case weeklyPeakPerformance = "weekly-peak-performance" // myData
    case comingEvent = "coming-event" // myPreparations
    case myPreps = "prepare-my-preps" // prepareEvent
    case contentCategory = "content-category"
    case featureExplainer = "feature-explainer" // randomContent
    case strategies = "strategies" // knowFeed
    case meUniverse = "me-universe" // myQot
    case meMyWhy = "me-my-why" // myData
    case meChoices = "me-choices" // myData
    case meActivity = "me-activity" // myData
    case meIntensity = "me-intensity" // myData
    case meMeeting = "me-meeting" // myData
    case meSleep = "me-sleep" // myData
    case mePeakPerformance = "me-peakperformance" // myData
    case meQotPartner = "me-qot-partner" // myQOT
    case meTravel = "me-travel" // myQOT
    case preferencesSyncCalendar = "preferences-sync-calendar" // syncedCcalendars
    case preferencesNotification = "preferences-notification" // appSettings
    case addSensor = "add-sensor" // activityTrackers
    case prepare = "prepare" // myPreparations
    case prepareProblem = "prepare-problem" // solveAChallenge
    case prepareDay = "prepare-day" // prepareEvent
    case library = "library" // tools
    case guide = "guide" // dailyBrief
    case contentItem = "contentItem" //content-item
    case fitbitApp = "fitbit" // activityTrackers
    case signingVerificationCode = "verificationCode" // login
    case profile = "profile" // accountSetting
    case siriSettings = "siri-settings" // siriShortcuts
    case teamInvitations = "team-invitations" // open pending team invites
    case generateToBeVision = "generate-tobevision"
    case myBookmarks = "my-bookmarks"
    case myDownloads = "my-downloads"

    var queryNames: [String] {
        switch self {
        case .dailyBrief,
             .guide: return ["bucketName"]
        case .ouraring: break
        case .fitbit: return ["code"]
        case .content_item: return ["contentItemId"]
        case .contentItem: return ["contentID"]
        case .knowFeed,
             .strategies: break
        case .myQOT,
             .meUniverse,
             .meQotPartner,
             .meTravel: break
        case .coachMode: break
        case .myData,
             .weeklyPeakPerformance,
             .meMyWhy,
             .meChoices,
             .meActivity,
             .meIntensity,
             .meMeeting,
             .meSleep,
             .mePeakPerformance: break
        case .createSolveAChallenge,
             .prepareProblem: break
        case .planASprint: break
        case .tools: break
        case .library: break
        case .siriShortCuts,
             .siriSettings: break
        case .myPreparations,
             .myPreps,
             .comingEvent,
             .prepare: break
        case .prepareEvent,
             .prepareDay: break
        case .preparation: return ["identifier"]
        case .toBeVision: return ["teamId"]
        case .tbvTrackerPollOpened: return ["teamId"]
        case .tbvTrackerPollClosed: return ["teamId"]
        case .tbvGeneratorPollOpened: return ["teamId"]
        case .tbvGeneratorPollClosed: return ["teamId"]
        case .mySprints: break
        case .myLibrary: return ["teamId", "category"]
        case .myProfile: break
        case .accountSetting,
             .profile: break
        case .appSettings,
             .preferencesNotification: break
        case .syncedCalendars,
             .preferencesSyncCalendar: break
        case .activityTrackers,
             .addSensor,
             .fitbitApp: break
        case .dailyCheckIn,
             .dailyPrep: break
        case .latestWhatsHotArticle: break
        case .support: break
        case .tutorial: break
        case .faq: break
        case .aboutTignum: break
        case .qotBenefits: break
        case .aboutTignumDetail: break
        case .privacy: break
        case .termsAndConditions: break
        case .contentCopyrights: break
        case .performanceFoundation: break
        case .performanceHabituation: break
        case .performanceRecovery: break
        case .performanceNutrition: break
        case .performanceMovement: break
        case .performanceMindset: break
        case .contentCategory: return ["collectionID"]
        case .randomContent: return ["contentId"]
        case .featureExplainer:  return ["contentID"]
        default: break
        }
        return []
    }

    func launchPathWithParameterValue(_ value: String) -> String {
        guard let urlSchemes = URLScheme.urlSchemes() else { return "tignumx://" }
        var urlString = "\(urlSchemes[0])://\(self.rawValue)"
        let queryNamesCount = queryNames.count
        if queryNamesCount > 0 {
            urlString = "\(urlSchemes[0])://\(self.rawValue)?"
            for (index, queryName) in queryNames.enumerated() {
                urlString.append("\(queryName)=\(value)")
                if index + 1 < queryNamesCount {
                    urlString.append("&")
                }
            }
        }
        return urlString
    }

    func launchURLWithParameterValue(_ value: String) -> URL? {
        return URL(string: launchPathWithParameterValue(value))
    }

    func launchPathWith(_ value: [String: String]) -> String {
        guard let urlSchemes = URLScheme.urlSchemes() else { return "tignumx://" }
        var urlString = "\(urlSchemes[0])://\(self.rawValue)"
        if !queryNames.isEmpty {
            urlString = "\(urlSchemes[0])://\(self.rawValue)?"
            for name in queryNames where value[name] != nil {
                urlString += "\(name)=\(value[name]!)"
            }
        }
        return urlString
    }

    func launchURLWith(_ value: [String: String]) -> URL? {
        return URL(string: launchPathWith(value))
    }

    static func isSupportedURL(_ url: URL) -> Bool {
        guard
            let host = url.host,
            URLScheme(rawValue: host) != nil else {
                return false
        }
        return true
    }

    static func urlSchemes() -> [String]? {
        guard let urlTypes = Bundle.main.infoDictionary?["CFBundleURLTypes"] as? [[String: Any]] else { return nil }
        #if DEBUG
        return urlTypes.first?["CFBundleURLSchemes"] as? [String]
        #else
        return urlTypes.last?["CFBundleURLSchemes"] as? [String]
        #endif
    }

    static func dailyBriefURL(for bucket: DailyBriefBucketName) -> URL? {
        guard let urlSchemes = urlSchemes() else { return nil }
        let dailyBrief = URLScheme.dailyBrief
        return URL(string: "\(urlSchemes[0])://\(dailyBrief.rawValue)?\(dailyBrief.queryNames)=\(bucket)")
    }

    static func preparationURL(withID localID: String) -> String? {
        guard let urlSchemes = urlSchemes() else { return nil }
        let preparation = URLScheme.preparation
        return "\(urlSchemes[0])://\(preparation.rawValue)?\(preparation.queryNames)=\(localID)"
    }

    static func isLaunchableHost(host: String?) -> Bool {
        guard let host = host, let urlScheme = URLScheme(rawValue: host) else { return false }
        return urlScheme != .fitbit &&
            urlScheme != .fitbitAuthrefresh &&
            urlScheme != .fitbitApp &&
            urlScheme != .signingVerificationCode
    }
}
