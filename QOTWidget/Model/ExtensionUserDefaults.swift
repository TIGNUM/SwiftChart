//
//  UserDefaultValues.swift
//  QOTWidget
//
//  Created by Javier Sanz Rozalen on 09/07/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

enum SuiteName: String, CaseIterable {
    case widget = "group.widget.com.tignum.qot.novartis"
    case siri = "group.siri.com.tignum"
    case share = "group.share.tignum.qot.novartis"
}

enum ExtensionUserDefaults: String, CaseIterable {

    case toBeVision = "qot.userdefault.key.toBeVision"
    case isUserSignedIn = "qot.userdefault.key.isUserSignedIn"
    case whatsHot = "qot.userdefault.key.whatshotarticles"
    case upcomingEvents = "qot.userdefault.key.upcomingEvents"
    case dailyPrep = "qot.userdefault.key.dailyPrep"
    case siriAppEvents = "qot.userdefault.key.siriAppEvents"
    case saveLink = "qot.userdefault.key.saveExternalLink"

    // MARK: - DELETE

    func clearWidgetObject() {
        for suiteName in SuiteName.allCases {
            let userDefaults = UserDefaults(suiteName: suiteName.rawValue)
            userDefaults?.removeObject(forKey: self.rawValue)
            userDefaults?.synchronize()
        }
    }

    // MARK: - SET
    
    static func set<T: Encodable>(_ object: T, for key: ExtensionUserDefaults) {
        for suiteName in SuiteName.allCases {
            let userDefaults = UserDefaults(suiteName: suiteName.rawValue)
            userDefaults?.set(try? PropertyListEncoder().encode(object), forKey: key.rawValue)
        }
    }

    static func set<T: Encodable>(_ object: T, for key: ExtensionUserDefaults, in suite: SuiteName) {
        let userDefaults = UserDefaults(suiteName: suite.rawValue)
        userDefaults?.set(try? PropertyListEncoder().encode(object), forKey: key.rawValue)
        userDefaults?.synchronize()
    }

    static func setIsUserSignedIn(value: Bool) {
        for suiteName in SuiteName.allCases {
            UserDefaults(suiteName: suiteName.rawValue)?.set(value, forKey: isUserSignedIn.rawValue)
        }
    }

    static var isSignedIn: Bool {
        return ExtensionUserDefaults.isUserSignedIn.value(for: .siri) as? Bool ?? false
    }

    // MARK: - GET

    func value(for suiteName: SuiteName) -> Any? {
        return UserDefaults(suiteName: suiteName.rawValue)?.object(forKey: rawValue)
    }

    static func object<T: Decodable>(for suiteName: SuiteName, key: ExtensionUserDefaults) -> T? {
        guard
            let userDefaults = UserDefaults(suiteName: suiteName.rawValue),
            let data = userDefaults.value(forKey: key.rawValue) as? Data else { return nil }
        return try? PropertyListDecoder().decode(T.self, from: data)
    }

    // MARK: - REMVOE
    static func removeObject(for suiteName: SuiteName, key: ExtensionUserDefaults) {
        guard let userDefaults = UserDefaults(suiteName: suiteName.rawValue) else { return }
        userDefaults.removeObject(forKey: key.rawValue)
        userDefaults.synchronize()
    }
}
