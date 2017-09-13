//
//  RealmProvider.swift
//  QOT
//
//  Created by Sam Wyndham on 30/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

class RealmProvider {
    func realm() throws -> Realm {
        let configuration = try DatabaseManager.shared.configuration()
        return try Realm(configuration: configuration)
    }
}
