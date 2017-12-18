//
//  Guide.swift
//  QOT
//
//  Created by karmic on 11.12.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import RealmSwift
import Freddy

final class RealmGuide: Object {

    @objc dynamic var createdAt: Date = Date()

    var items = List<RealmGuideItem>()

    convenience init(items: List<RealmGuideItem>) {
        self.init()
        self.items = items
        createdAt = Date().startOfDay
    }
}
