//
//  Realm+TestUtils.swift
//  QOT
//
//  Created by Sam Wyndham on 17/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

extension Realm {
    static func inMemory() -> Realm {
        return try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: UUID().uuidString))
    }
}
