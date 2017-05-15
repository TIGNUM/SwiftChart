//
//  PrepareContentCollection.swift
//  QOT
//
//  Created by karmic on 12.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

protocol PrepareContentCollection: TrackableEntity {
    var title: String { get }

    var localID: String { get }

    var selected: Bool { get }
}

extension ContentCollection: PrepareContentCollection {

    var localID: String {
        return String(Int.randomID)
    }

    var selected: Bool {
        return viewed
    }
}
