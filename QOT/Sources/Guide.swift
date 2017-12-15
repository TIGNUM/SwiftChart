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

final class Guide: Object {

    @objc dynamic var createdAt: Date = Date()

    var items = List<GuideItem>()

    convenience init(items: List<GuideItem>) {
        self.init()
        self.items = items
        createdAt = Date().startOfDay
    }
}
