//
//  Tutorials.swift
//  QOT
//
//  Created by Moucheg Mouradian on 24/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

enum Tutorial: Int {
    case learn
    case me
    case prepare

    var key: String {
        switch self {
        case .learn: return "learnTutorial"
        case .me: return "meTutorial"
        case .prepare: return "prepareTutorial"
        }
    }

    func exists() -> Bool {
        return UserDefaults.standard.bool(forKey: key)
    }

    func set() {
        UserDefaults.standard.set(true, forKey: key)
    }

    func remove() {
        UserDefaults.standard.removeObject(forKey: key)
    }

    static func resetTutorial() {
        Tutorial.learn.remove()
        Tutorial.me.remove()
        Tutorial.prepare.remove()
    }
}
