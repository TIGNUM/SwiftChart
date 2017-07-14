//
//  UserDefault+Convenience.swift
//  QOT
//
//  Created by karmic on 03.07.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

enum UserDefault: String {
    case qotUsage = "qot.userdefault.key.usage.in.minutes"
}

extension UserDefault {

    static func objectsToClearOnLogout() -> [UserDefault] {
        return [.qotUsage]
    }

    func setBoolValue(value: Bool) {
        UserDefaults.standard.set(value, forKey: self.rawValue)
        UserDefaults.standard.synchronize
    }

    var boolValue: Bool {
        return UserDefaults.standard.bool(forKey: self.rawValue)
    }

    var doubleValue: Double {
        return UserDefaults.standard.double(forKey: self.rawValue)
    }

    func setDoubleValue(value: Double) {
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
