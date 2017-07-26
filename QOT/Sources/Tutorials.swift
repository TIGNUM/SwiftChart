//
//  Tutorials.swift
//  QOT
//
//  Created by Moucheg Mouradian on 24/07/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

enum Tutorials {
    case learnTutorial
    case meTutorial
    case prepareTutorial

    var key: String {
        switch self {
        case .learnTutorial: return "learnTutorial"
        case .meTutorial: return "meTutorial"
        case .prepareTutorial: return "prepareTutorial"
        }
    }

    func exists() -> Bool {
        return UserDefaults.standard.bool(forKey: self.key)
    }

    func set() {
        UserDefaults.standard.set(true, forKey: self.key)
    }

    func remove() {
        UserDefaults.standard.removeObject(forKey: self.key)
    }

    static func resetTutorial() {
        Tutorials.learnTutorial.remove()
        Tutorials.meTutorial.remove()
        Tutorials.prepareTutorial.remove()
    }
}
