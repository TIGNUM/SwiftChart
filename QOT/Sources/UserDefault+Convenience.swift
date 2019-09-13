//
//  UserDefault+Convenience.swift
//  QOT
//
//  Created by karmic on 03.07.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

enum UserDefault: String {
    case skipTBVCounter = "com.tignum.qot.skipTBVCounter"
    case calendarDictionary = "qot.userdefault.key.calendar.dictionary"
    case newGuideItem = "qot.userdefault.key.new.guide.item"
    case lastInstaledAppVersion = "qot.userdefault.key.last.installed.app.version"
    case hasShownOnbordingSlideShowInAppBuild = "qot.userdefault.key.onboardingSlideShow"
    case whatsHotListLastViewed = "qot.userdefault.key.whatsHotListLastViewed"
    case iPadAdviceDoNotShowAgain = "qot.userdefault.key.iPadAdviceDoNotShowAgain"
    case whatsHotBadgeNumber = "qot.userdefault.key.new.whats.hot.badge.number"
    case guideBadgeNumber = "qot.userdefault.key.new.guide.badge.number"
    case firstInstallationTimestamp = "qot.userdefault.key.first.installation.timestamp"
    case restartRouteURLString = "qot.userdefault.key.restart.routeURL.string"
    case subscriptionInfoShow = "qot.userdefault.key.subscription.info.show"
    case finishedAudioItems = "qot.userdefault.key.finished.audio.items.dictionary"
    case myDataSelectedItems = "qot.userdefault.key.my.data.selected.items.dictionary"
    case didShowCoachMarks = "qot.userdefault.key.didShowCoachMarks"
    case showGuideTrackBucket = "qot.userdefault.key.hideGuideTrackBuckets"
}

extension UserDefault {

    static func objectsToClearOnLogout() -> [UserDefault] {
        return [.calendarDictionary,
                .whatsHotListLastViewed,
                .iPadAdviceDoNotShowAgain,
                .whatsHotBadgeNumber,
                .guideBadgeNumber,
                .restartRouteURLString,
                .subscriptionInfoShow,
                .finishedAudioItems,
                .myDataSelectedItems,
                .showGuideTrackBucket]
    }

    static func objectsToClearOnNewRegistration() -> [UserDefault] {
        return [.calendarDictionary,
                .newGuideItem,
                .lastInstaledAppVersion,
                .hasShownOnbordingSlideShowInAppBuild,
                .whatsHotListLastViewed,
                .iPadAdviceDoNotShowAgain,
                .whatsHotBadgeNumber,
                .guideBadgeNumber,
                .firstInstallationTimestamp,
                .restartRouteURLString,
                .subscriptionInfoShow,
                .finishedAudioItems,
                .myDataSelectedItems,
                .showGuideTrackBucket]
    }

    var boolValue: Bool {
        return UserDefaults.standard.bool(forKey: self.rawValue)
    }

    var doubleValue: Double {
        return UserDefaults.standard.double(forKey: self.rawValue)
    }

    var stringValue: String? {
        return UserDefaults.standard.string(forKey: self.rawValue)
    }

    var object: Any? {
        return UserDefaults.standard.object(forKey: self.rawValue)
    }

    func setObject(_ object: Any?) {
        UserDefaults.standard.setValue(object, forKey: self.rawValue)
        UserDefaults.standard.synchronize()
    }

    func setBoolValue(value: Bool) {
        UserDefaults.standard.set(value, forKey: self.rawValue)
        UserDefaults.standard.synchronize()
    }

    func setDoubleValue(value: Double) {
        UserDefaults.standard.set(value, forKey: self.rawValue)
        UserDefaults.standard.synchronize()
    }

    func setStringValue(value: String) {
        UserDefaults.standard.set(value, forKey: self.rawValue)
        UserDefaults.standard.synchronize()
    }

    func clearObject() {
        UserDefaults.standard.removeObject(forKey: self.rawValue)
        UserDefaults.standard.synchronize()
    }

    static func clearAllDataLogOut() {
        ExtensionUserDefaults.allCases.forEach { $0.clearWidgetObject() }
        self.objectsToClearOnLogout().forEach { $0.clearObject() }
    }

    static func clearAllDataRegistration() {
        self.objectsToClearOnNewRegistration().forEach { $0.clearObject() }
    }
}
