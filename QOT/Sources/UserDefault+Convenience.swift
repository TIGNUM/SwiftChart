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
    case firstInstallationTimestamp = "qot.userdefault.key.first.installation.timestamp"
    case restartRouteURLString = "qot.userdefault.key.restart.routeURL.string"
    case subscriptionInfoShow = "qot.userdefault.key.subscription.info.show"
    case finishedAudioItems = "qot.userdefault.key.finished.audio.items.dictionary"
    case myDataSelectedItems = "qot.userdefault.key.my.data.selected.items.dictionary"
    case didShowCoachMarks = "qot.userdefault.key.didShowCoachMarks"
    case showGuideTrackBucket = "qot.userdefault.key.showsGuideTrackBuckets"
    case prepareLocalEventsDictionary = "qot.userdefault.key.prepare.local.events.dictionary"
    case myBestDate = "qot.userdefault.key.my.best.date"
    case myBestText = "qot.userdefault.key.my.best.text"
    case existingEmail = "qot.userdefault.key.existing.email"
    case sprintExplanation = "qot.userdefault.key.sprint.explanation.seen"
    case toolsExplanation = "qot.userdefault.key.tools.explanation.seen"
    case prepareExplanation = "qot.userdefault.key.prepare.explanation.seen"
    case solveExplanation = "qot.userdefault.key.solve.explanation.seen"
    case mindsetExplanation = "qot.userdefault.key.mindset.explanation.seen"
    case recoveryExplanation = "qot.userdefault.key.recovery.explanation.seen"
    case showTableViewSwipeDemo = "qot.userdefault.key.show.table.view.swipe.demo"
}

extension UserDefault {
    static func objectsToClearOnLogout() -> [UserDefault] {
        return [.calendarDictionary,
                .whatsHotListLastViewed,
                .iPadAdviceDoNotShowAgain,
                .restartRouteURLString,
                .subscriptionInfoShow,
                .finishedAudioItems,
                .myDataSelectedItems,
                .prepareLocalEventsDictionary,
                .existingEmail,
                .showTableViewSwipeDemo]
    }

    static func objectsToClearOnNewRegistration() -> [UserDefault] {
        return [.calendarDictionary,
                .newGuideItem,
                .lastInstaledAppVersion,
                .hasShownOnbordingSlideShowInAppBuild,
                .whatsHotListLastViewed,
                .iPadAdviceDoNotShowAgain,
                .firstInstallationTimestamp,
                .restartRouteURLString,
                .subscriptionInfoShow,
                .finishedAudioItems,
                .myDataSelectedItems,
                .prepareLocalEventsDictionary,
                .existingEmail,
                .showTableViewSwipeDemo]
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
    }

    func setBoolValue(value: Bool) {
        UserDefaults.standard.set(value, forKey: self.rawValue)
    }

    func setDoubleValue(value: Double) {
        UserDefaults.standard.set(value, forKey: self.rawValue)
    }

    func setStringValue(value: String) {
        UserDefaults.standard.set(value, forKey: self.rawValue)
    }

    func clearObject() {
        UserDefaults.standard.removeObject(forKey: self.rawValue)
    }

    static func clearAllDataLogOut() {
        ExtensionUserDefaults.allCases.forEach { $0.clearWidgetObject() }
        self.objectsToClearOnLogout().forEach { $0.clearObject() }
    }

    static func clearAllDataRegistration() {
        self.objectsToClearOnNewRegistration().forEach { $0.clearObject() }
    }
}
