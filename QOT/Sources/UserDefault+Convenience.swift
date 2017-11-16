//
//  UserDefault+Convenience.swift
//  QOT
//
//  Created by karmic on 03.07.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

enum UserDefault: String {
    case locationService = "qot.userdefault.key.location.service"
    case calendarDictionary = "qot.userdefault.key.calendar.dictionary"
    case newWhatsHotArticle = "qot.userdefault.key.new.whats.hot.article"
    case lastInstaledAppVersion = "qot.userdefault.key.last.installed.app.version"
}

extension UserDefault {

    static func objectsToClearOnLogout() -> [UserDefault] {
        return [.locationService, .calendarDictionary, .newWhatsHotArticle]
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

    static func clearAllData() {
        self.objectsToClearOnLogout().forEach { (userDefault) in
            userDefault.clearObject()
        }
    }
}
