//
//  RealmProvider.swift
//  QOT
//
//  Created by Sam Wyndham on 30/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

final class RealmProvider {
    func realm() throws -> Realm {
        return try Realm()
    }
}
